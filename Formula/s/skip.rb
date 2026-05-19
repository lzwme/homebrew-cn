class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.8.15.tar.gz"
  sha256 "60835fa1529e1cdddde1231f8597fa17de4d3f8000ad0bfa691da7d27dab9a38"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "cbd4d7748694abc6bd1b90474adad49c6fed631b1d408a5c7f860e08e1752095"
    sha256                               arm64_sequoia: "606ceafa9d027c983957f827673d46fdf8843ba48ae6329c651be4beaddf1999"
    sha256                               arm64_sonoma:  "e7977ebf7af045ea971f78f3f96a16f95168ae70e275f78b365c7f499c2bd12d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca9503a95d1d68c16ba0df11de2c8faabf88806726f2a26968182652c3183b04"
    sha256                               arm64_linux:   "1faf8eaa520a41a73640463596fc7b71a352a8f14b31af41be1391f17e6fadfa"
    sha256                               x86_64_linux:  "89642b8e8a1793febfcd0187e2b41a402bc509b6df22c63548bfa8eb3a87a67e"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.8.15.tar.gz"
    sha256 "f6dc8e935c699b1e398f2bc9c0ba93a44d951d9bc6340161303c8671575e7843"

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