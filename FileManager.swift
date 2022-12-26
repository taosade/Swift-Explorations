// Using FileManager to save/retrieve/delete files.

import SwiftUI

class LocalFileManager
{
	static let instance = LocalFileManager()

	init() { initFolder() }

	/// Creates '/images' folder in the user's caches directory if there isn't already
	private func initFolder()
	{
		guard
			let path = FileManager
			.default
			.urls(for: .cachesDirectory, in: .userDomainMask)
			.first?
			.appendingPathComponent("images")
			.path,
			!FileManager.default.fileExists(atPath: path)
		else { return }

		do { try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true) }
		catch let error { print(error.localizedDescription) }
	}

	/// Constructs URL for JPG image with specified name
	private func getPath(for name: String) -> URL?
	{
		guard let path = FileManager
			.default
			.urls(for: .cachesDirectory, in: .userDomainMask)
			.first?
			.appendingPathComponent("images", isDirectory: true)
			.appendingPathComponent("\(name).jpg", conformingTo: .image)
		else { return nil }

		return path
	}

	/// Saves image to FileManager
	func saveImage(image: UIImage, name: String)
	{
		guard
			let data = image.pngData(),
			let path = getPath(for: name)
		else { return }

		do
		{
			try data.write(to: path)

			print ("Image saved")
		}
		catch let error { print(error.localizedDescription) }
	}

	/// Deletes image from FileManager if there's one
	func deleteImage(name: String)
	{
		guard
			let path = getPath(for: name)?.path,
			FileManager.default.isDeletableFile(atPath: path)
		else { return }

		do
		{
			try FileManager.default.removeItem(atPath: path)

			print("Image deleted")
		}
		catch let error { print(error.localizedDescription) }
	}

	/// Gets image from FileManager if there's one
	func getImage(name: String) -> UIImage?
	{
		guard
			let path = getPath(for: name)?.path,
			FileManager.default.fileExists(atPath: path)
		else { return nil }

		return UIImage(contentsOfFile: path)
	}
}

class MyViewModel: ObservableObject
{
	@Published var image: UIImage?

	let name = "image" // Name of the JPG image from the assets folder

	func saveImage()
	{
		guard let image = UIImage(named: name) else { return }

		LocalFileManager.instance.saveImage(image: image, name: name)
	}

	func deleteImage()
	{
		LocalFileManager.instance.deleteImage(name: name)
	}

	func getImage()
	{
		image = LocalFileManager.instance.getImage(name: name)
	}
}

struct ContentView: View
{
	@StateObject var vm = MyViewModel()

	var body: some View
	{
		VStack(spacing: 20)
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
				Button("Save image to FileManager")
				{
					vm.saveImage()
				}

				Button("Delete image from FileManager")
				{
					vm.deleteImage()
				}

				Button("Get image from FileManager")
				{
					vm.getImage()
				}
			}.buttonStyle(.bordered)

			Spacer(minLength: 0)
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
