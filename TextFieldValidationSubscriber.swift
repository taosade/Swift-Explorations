// Subscribing to published var to validate TextField input

import SwiftUI
import Combine

class MyViewModel: ObservableObject
{
	var cancellables = Set<AnyCancellable>()

	@Published var text: String = ""
	@Published var valid: Bool = false

	init()
	{
		$text
		.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
		.map { text in return text.count >= 3 }
		.sink{ [weak self] valid in self?.valid = valid }
		.store(in: &cancellables)
	}
}

struct ContentView: View
{
	@StateObject var vm = MyViewModel()

	var body: some View
	{
		TextField("Type at least three characters…", text: $vm.text)
		.padding()
		.background((vm.valid ? Color.green : Color.red).opacity(0.33))
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider
{
	static var previews: some View
	{
		ContentView()
	}
}
