class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https:github.comperipheryappperiphery"
  url "https:github.comperipheryappperipheryarchiverefstags3.0.3.tar.gz"
  sha256 "7b4ccfea2879b7f3f5f53e328bb990c6896d8a5e62ff5a50c28ce6b7113d16e1"
  license "MIT"
  head "https:github.comperipheryappperiphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46f35e9045766af2c18532e26f4a66f773bc3417ecaebd1264ec1d5712e471fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edcfe044e2ae4240c65ff155b6c2f0a624d6ac1d91dcb7b9ff534636b2ca42ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "6164856e03fe166e7bff671b086bdf21609edc8fe47200715583aa5123b261d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc25c77bedb7ad96a6749bd68ba66cb5f14d26b3b68183dfb46d37f5f0994e9"
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