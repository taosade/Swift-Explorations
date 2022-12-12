// Get JSON ftom HTTP endpoint, decode it to datamodel and present with SwiftUI

import SwiftUI

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

	init() { getPosts() }

	func getData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> Void)
	{
		URLSession.shared.dataTask(with: url)
		{
			(data, response, error) in

			if let error = error
			{
				print(error.localizedDescription)
				completionHandler(nil)
				return
			}

			guard let response = response as? HTTPURLResponse else
			{
				print("Invalid response")
				completionHandler(nil)
				return
			}

			guard (200...299).contains(response.statusCode) else
			{
				print("Invalid status code: \(response.statusCode)")
				completionHandler(nil)
				return
			}

			completionHandler(data)
		}
		.resume()
	}

	func getPosts()
	{
		guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

		getData(fromURL: url)
		{
			data in

			guard let data = data else { print("No data returned"); return }

			guard let posts = try? JSONDecoder().decode([PostModel].self, from: data) else
			{
				print("Could not decode data"); return
			}

			DispatchQueue.main.async { self.posts = posts }
		}
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
