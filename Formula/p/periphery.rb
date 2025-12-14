class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://ghfast.top/https://github.com/peripheryapp/periphery/archive/refs/tags/3.3.0.tar.gz"
  sha256 "2829c8041b9050154bda16fde19631c2643fb57a295abbf35032e921b1f41299"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ada30b903fbaeb550d36c4c72239d91102280308a79ef1328a881cb4359289e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79ef503524ebb841e878c36c38c6ab2f1cf6fc860e8d6e6e88b96435f70efe82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a405daf170bcfd04d26a99139b1842df5c02b3652e1fc6da1bacf7ae1ac26673"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d48a8238c7d0d75b1e55d25b98995dc64a8d2c78044fd691878ca490214e35f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d81ca160c43cfa6d3fa750cce53982c2a40a921aa7b043d0684e959f5ed42c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d6af0730d6edb3cac5abf3c56123dc67eba7f05dc30ee4e5de172235c8e7a1"
  end

  depends_on xcode: ["16.0", :build]

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "periphery"
    bin.install ".build/release/periphery"
    generate_completions_from_executable(bin/"periphery", "--generate-completion-script")
  end

  test do
    # Periphery dynamically loads 'libIndexStore' at runtime and must find its location depending on the host OS.
    # On macOS, the library is bundled within Xcode at a consistent location. On Linux, the library path is assumed
    # to be at 'lib/libIndexStore.so' relative to the path of the 'swift' binary, which is a reasonable assumption for
    # most installations. However, this is not the case on the Homebrew Linux test container, and the shared libraries
    # do not appear to be present.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"
  end
end