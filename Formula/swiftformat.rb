class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.51.13.tar.gz"
  sha256 "d0d24084bf6d5f0ce551702a200319830377e03ac012d845d672e5be314b88e5"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5cc21899f071087be9e7d5752528b5d88adad2f44f349f80fcb507df1342af6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b71ca6f59bb490148de145542afbedcffddbcee3455e92549cdbd8b6246a4c99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0b422a09041aa3b3d8f9d5e6bfb0da3a33fd766f09783ef85798e2ebdec71cb"
    sha256 cellar: :any_skip_relocation, ventura:        "3b142c2059b1bc5bd3940d4cf8941b660bc90c65ffe7020691f032888ba0ee51"
    sha256 cellar: :any_skip_relocation, monterey:       "57a9f32881e59148d40d29be9ed2b9980d2615de4818b996a257d57fe14f15ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "36c083a9372c8864e9df8f8d2236be9172a976637233c7fb7c60ded88f1780c3"
    sha256                               x86_64_linux:   "9729643b80ae1566e034e5d13b674a59901fb5a031ec7a483e5dc43338c9e96c"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end