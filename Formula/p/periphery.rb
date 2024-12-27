class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https:github.comperipheryappperiphery"
  url "https:github.comperipheryappperipheryarchiverefstags2.21.2.tar.gz"
  sha256 "97e399df17d1e681703c5c8852e50b40c056a98b41dc4c615011c048b8348dbb"
  license "MIT"
  head "https:github.comperipheryappperiphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90e7ebf5e8b80a237cb4c865e5decd603d5305e093af91818c733f4df515c3e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc4439d503cfb724360176264d06ea5cb7ea1335b0db896240209fb0644e9b8"
    sha256 cellar: :any,                 arm64_ventura: "e4ef3eb423e34cf776d3f5c806989b49aa492b892018b9a6c2715f604761cd1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a433da033183693c4f4855a5f2f557e4acd0f0fa7ebdf96df84da4e21b2dd7e"
    sha256 cellar: :any,                 ventura:       "5f5fedcfa7b6a62d0858e1e5515a7365d61c7cc4e78157b66e7355368a1ad55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdfc5440f8eac20b8290a4173cadfc81090b12ef78454bed09a1a5ef56e30b54"
  end

  uses_from_macos "swift" => [:build, :test], since: :sonoma # swift 5.10+
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