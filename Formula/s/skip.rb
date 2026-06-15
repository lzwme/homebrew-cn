class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.3.tar.gz"
  sha256 "87a2a527781250fa4858d695e5deaea3ee58658fd43201623d8ed8dcc58e3753"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "4faec1e16e4aff4f5edb1af39cb12739b8065f4c4e1bd1afee05d3de26113889"
    sha256                               arm64_sequoia: "c10f521fead73910be04a74c8a9f2fa4ac363d1475db8835e562205f568eb959"
    sha256                               arm64_sonoma:  "5dbe72bb429672d14d095b97fc18ca6ebea3eb5d6fa1f46c5d6205a240da6878"
    sha256 cellar: :any_skip_relocation, sonoma:        "0319e4db9ace71ecf7a96468bd15257e4d2dda1298f4cf5d47ba4e6580621d82"
    sha256                               arm64_linux:   "9781bee5ecef09e17f7b553b0a39f026f43d558d4a98ce6b3bfcf6576ad8fbe7"
    sha256                               x86_64_linux:  "fbca6e22b65dd151964f705a909230cbda82ed0e763d62959bee2e498686258f"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.3.tar.gz"
    sha256 "a68ff4db4e214ee9aee4d7b841415d258900567fad1835814b66cdfd015b8791"

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