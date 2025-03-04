class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https:github.comperipheryappperiphery"
  url "https:github.comperipheryappperipheryarchiverefstags3.0.2.tar.gz"
  sha256 "06c0f71e5afb2ae7ccbb53502500160aa2d8b6da2c9e48e61334c6b83c987a72"
  license "MIT"
  head "https:github.comperipheryappperiphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc6374bab0a0c2a0b48c8d3a873bf5f8adcdd524a036162305c4c49c3a85975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ce8c9c10db96a5769e44c0516516122bcf67ce068b5f436c049dcee9a8f1f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "024b3e374562e4d667540ab2ab4439480239cb87f4c0e143587c9ae808dd5712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a60eaa6f1fd4d9fcd54d0d5b19bdfc37f6e5dbe6fa7883e29c5209120388ab7"
  end

  depends_on xcode: ["15.4", :build]

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "periphery"
    bin.install ".buildreleaseperiphery"
  end

  test do
    # Periphery dynamically loads 'libIndexStore' at runtime and must find its location depending on the host OS.
    # On macOS, the library is bundled within Xcode at a consistent location. On Linux, the library path is assumed
    # to be at 'liblibIndexStore.so' relative to the path of the 'swift' binary, which is a reasonable assumption for
    # most installations. However, this is not the case on the Homebrew Linux test container, and the shared libraries
    # do not appear to be present.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"
  end
end