// Get JSON ftom HTTP endpoint, decode it to datamodel and present with SwiftUI

import SwiftUI
import Combine

struct PostModel: Identifiable, Codable
{
	let id: Int
	let userId: Int
	let title: String
	let body: String
}

class PostsViewModel: ObservableObject
{
	@Published var posts: [PostModel] = []

	var cancellables: Set<AnyCancellable> = []

	init() { getPosts() }

	func getPosts()
	{
		guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

		URLSession.shared.dataTaskPublisher(for: url)
		.subscribe(on: DispatchQueue.global(qos: .background))
		.receive(on: DispatchQueue.main)
		.tryMap
		{
			(data, response) -> Data in

			guard
				let response = response as? HTTPURLResponse,
				(200...299).contains(response.statusCode)
			else { throw URLError(.badServerResponse) }

			return data
		}
		.decode(type: [PostModel].self, decoder: JSONDecoder())
		.sink
		{
			completion in switch completion
			{
				case .finished: print("Finished")
				case .failure(let error): print(error.localizedDescription)
			}
		}
		receiveValue: { [weak self] posts in self?.posts = posts }
		.store(in: &cancellables)
	}
}

struct ContentView: View
{
	@StateObject var vm = PostsViewModel()

	var body: some View
	{
		if vm.posts.isEmpty { ProgressView() } else
		{
			ScrollView
			{
				VStack(alignment: .leading)
				{
					ForEach(vm.posts)
					{
						post in

						Text("#\(post.id) \(post.title)").font(.title)

						Text(post.body).padding(.vertical)
					}
				}.padding(.horizontal)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider
{
	static var previews: some View
	{
		ContentView()
	}
}
