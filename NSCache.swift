// Using NSCache for UIImage caching

import SwiftUI

class CacheManager
{
	static let instance = CacheManager()

	private init() {}

	private var images: NSCache<NSString, UIImage> =
	{
		let cache = NSCache<NSString, UIImage>()

		cache.countLimit = 10
		cache.totalCostLimit = 10 * 1024 // 10 Mb

		return cache
	}()

	func add(image: UIImage, name: String)
	{
		images.setObject(image, forKey: name as NSString)

		print("'\(name)' added to cache")
	}

	func get(name: String) -> UIImage?
	{
		return images.object(forKey: name as NSString)
	}

	func remove(name: String)
	{
		guard images.object(forKey: name as NSString) != nil
		else { return }

		images.removeObject(forKey: name as NSString)

		print("'\(name)' removed from cache")
	}
}

class MyViewModel: ObservableObject
{
	let imageName = "michael"

	@Published var image: UIImage? = nil
}

struct ContentView: View
{
	@StateObject var vm = MyViewModel()

	var body: some View
	{
		VStack
		{
			if let image = vm.image
			{
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
					.frame(height: 300)
			}

			Group
			{
				Button("Get from assets")
				{
					vm.image = UIImage(named: vm.imageName)
				}

				Button("Save to cache")
				{
					guard let image = vm.image else { return }

					CacheManager.instance.add(image: image, name: vm.imageName)
				}

				Button("Get from cache")
				{
					vm.image = CacheManager.instance.get(name: vm.imageName)
				}

				Button("Delete from cache")
				{
					CacheManager.instance.remove(name: vm.imageName)
				}
			}
			.buttonStyle(.borderedProminent)

			Spacer()
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
