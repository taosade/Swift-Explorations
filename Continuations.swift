// Using continuation to wrap synchronous code with callbacks inside an async function

import SwiftUI

class ContinuationDataManager
{
	// Regular async/await function

	func getData(url: URL) async throws -> Data
	{
		do
		{
			let (data, _) = try await URLSession.shared.data(from: url)

			return data
		}
		catch { throw URLError(.notConnectedToInternet) }
	}

	// Async function using a continuation to wrap synchronous code with callbacks

	func getDataWithContinuation(url: URL) async throws -> Data
	{
		try await withCheckedThrowingContinuation
		{
			continuation in

			URLSession.shared.dataTask(with: url)
			{
				data, _, error  in

				if let data = data { continuation.resume(returning: data) }
				else if let error = error { continuation.resume(throwing: error) }
				else { continuation.resume(throwing: URLError(.badServerResponse)) }
			}
			.resume()
		}
	}
}

class ContinuationViewModel: ObservableObject
{
	@Published var image: UIImage? = nil
	@Published var imageWithContinuation: UIImage? = nil

	let DM = ContinuationDataManager()

	func getImages() async
	{
		do
		{
			guard let url = URL(string: "https://picsum.photos/200")
			else { throw URLError(.badURL) }

			Task // Get image #1
			{
				let data = try await DM.getData(url: url)

				await MainActor.run { self.image = UIImage(data: data) }
			}

			Task // Get image #2
			{
				let data = try await DM.getDataWithContinuation(url: url)

				await MainActor.run { self.imageWithContinuation = UIImage(data: data) }
			}
		}
		catch { print(error.localizedDescription) }
	}
}

struct ContinuationView: View
{
	@StateObject private var VM = ContinuationViewModel()

	var body: some View
	{
		VStack(spacing: 100)
		{
			if let image = VM.image // Show image #1
			{
				Image(uiImage: image)
				.resizable()
				.scaledToFit()
				.frame(width: 200, height: 200)
			}

			if let image = VM.imageWithContinuation // Show image #2
			{
				Image(uiImage: image)
				.resizable()
				.scaledToFit()
				.frame(width: 200, height: 200)
			}
		}
		.task { await VM.getImages() }
	}
}

struct 	ContinuationView_Previews: PreviewProvider
{
	static var previews: some View
	{
		ContinuationView()
	}
}
