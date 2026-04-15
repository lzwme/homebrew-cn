class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.8.7.tar.gz"
  sha256 "8692852168fbcfb4a9afb20a2a9a1a1e74996ce320a53c0e43905d2a62dd4e16"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "bfbd1a1558e9c350d676392d9d415985006d36b9722653b112812f4e3c5338d4"
    sha256                               arm64_sequoia: "a5834c36810538d5c36e11648a0e865ae8b316e95e9624e469abb291ab10fd3b"
    sha256                               arm64_sonoma:  "2f4916a4b067911b5cfd1a92c58c52d51690b6034d3b2a3605c12cc5ebc9b85b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c9f06c35a55a5b8ad5379c5c23a69b554bb39ea2c60d922cc3942ef5b8f9c49"
    sha256                               arm64_linux:   "2dd7f9aab1d2e8f09c7e235f298ec9616ac57e66191b7f7e255d35e6706c6457"
    sha256                               x86_64_linux:  "3439f5115f08c4fddadcedf7045e94c22e16fd483618e8f41bca082017fdb33b"
  end

  depends_on xcode: :build
  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.8.7.tar.gz"
    sha256 "188c8fe89c434da542cd326a0757ee9a6019ea5302b9318677a099c8b1b1fc3b"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "SkipRunner"
    bin.install ".build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end