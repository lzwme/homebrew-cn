class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.5.tar.gz"
  sha256 "2cd480cb1372ed585b26b06a59031a38a6d2f54f678c44885eb54f14c9ecdcdb"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "ec9a734664b33f3f65eb7afa8e615a364829ebbe5928f7ff0eec7d1bfcd7beaa"
    sha256                               arm64_sequoia: "653ce7a1d95b69313a6276962272f68c055c333f0014e962e6884df6c9260128"
    sha256                               arm64_sonoma:  "991ea7133c0e761f02d9364172e5355ef62b2ca1606ad570ea6e8e00c9016061"
    sha256 cellar: :any_skip_relocation, sonoma:        "74d80b08dc4610ef2c5590c20aa6f88ace7ad431a4d3c44ef2afc6fc3e0077d5"
    sha256                               arm64_linux:   "6b5ed894f3a9c203294c3ca2424fc78717119f082a979729d0987bdc89d024f5"
    sha256                               x86_64_linux:  "a214c209cc255477acdd1ed4424cf37155fef210b2c22915395eadd1b2b61774"
  end

  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.5.tar.gz"
    sha256 "2d376159d0651cb18894447abae4c2fc5ac1c36e196b639451579d601539bfd9"

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