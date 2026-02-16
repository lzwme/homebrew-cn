class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://ghfast.top/https://github.com/peripheryapp/periphery/archive/refs/tags/3.5.1.tar.gz"
  sha256 "c332838cbf08e8681da3499ef32875f31c13ddcade15e622fcea08a34e618b58"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7a08947459f0c7b22faed8f6162551fdd971eb53bad7bfa46c290feead8e7e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a4d8e2831139eeb20bf073fda7ae39762ee26a17b0ae0913e94865ce4e2499f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc2e90675990055fe98d8e1ea0475643fd594ffdf7f2cc6bc499c2863dd731d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bea09c4325564630fb79a04938a2c18cb30d58dfb6919828db7889f03260120"
  end

  depends_on xcode: ["16.4", :build]

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
    ENV.prepend_path "PATH", Formula["swift"].opt_libexec/"bin" if OS.linux?

    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"
  end
end