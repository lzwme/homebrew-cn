class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.52.0.tar.gz"
  sha256 "ce31df4e106f08eb6e69b68eca75dfd79ad54e2ae96aeaa5717adbac93821da6"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee55cfc0770cb9d72b274b4e4d514bb12da561a2d67fe29f1f38db179bfb27f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ddac39b840c18aacb0bbbe347cb3381a59ea3a3b236b616265b2315ef8ee5a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c93b6a3ef115e7fce822d2ebc320131de2e78809bfe353ae0c55b73bff2bf5e2"
    sha256 cellar: :any_skip_relocation, ventura:        "0382acc93cc7c8cc7baab13403cc7971bbb1c56a9a335028b1ce1dc2328771e6"
    sha256 cellar: :any_skip_relocation, monterey:       "46de48bbed5ffa2884c55ae04d48d146a4ccc7806f3ca08d7f67bd261c3fc0e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "daa3efdf2db5dc5a6320b186f4f190f7f47a4dd9380570763ff0e355cdd4cb2a"
    sha256                               x86_64_linux:   "457ea37d520409c9c30d64569952c96b04e1922a2ec5cf9c53d1fd63357a6833"
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