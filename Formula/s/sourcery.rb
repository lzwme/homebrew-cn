class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://ghproxy.com/https://github.com/krzysztofzablocki/Sourcery/archive/2.1.0.tar.gz"
  sha256 "656f3b8b9463ae3a2afaf0bdcd55a03e7141d52a49e7fce1f4092991c14897e1"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3df6faef9028d8647dc275cad471f255d84a1befeeb28ca601bc517de1e705db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b18f07023f563c3152ea345e09cbd3fcbd2cb7cf6aa6938c228717dabbd26f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "e310f2b9ff6249a7fbdddebe234ba8426a253406d5e22932f0df4180b28f7ce5"
    sha256 cellar: :any_skip_relocation, ventura:       "60aae10574ccb3e26d2e9c0e03ec5e05cd626e89e91f414732f2177a5a1e6c6e"
    sha256                               x86_64_linux:  "d04a75e6f9432d5f45aeb7b71c5607b74dd395b71f978c394db3782e9b78532e"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end