class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.9.tar.gz"
  sha256 "d98d9a883f896452a7131268a6c20cbfacaf8a7ae980184b5bf4d0f7923d9be1"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "27b8cfbdf71a364b5c2cc020b83dcc4abc8fca88e06968d745b5ffa5cc8f260f"
    sha256 arm64_tahoe:       "642ca257f91f79132c70693303b19e1f4d2c39e021093fb6f42c7279fcc9c246"
    sha256 arm64_sequoia:     "3591f92e2e96bc333137c1d6fd3ac6770ce23c55b439571dcdea82580ac6cf10"
    sha256 arm64_linux:       "2b89cb8f33c510b43ef358872c683d8f565ecae0a04d240d7fb312e9003c3c74"
    sha256 x86_64_linux:      "4f9626f104e1db4848522a0b59bc2df80fdf3fabe7ac27675307649667baf247"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.9.tar.gz"
    sha256 "ee58cf11fdbe6b0791f068a2dd0fe584f019dc06b1c09418815f652bd5d1097d"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    system "swift", "build", "--product", "SkipRunner", *std_swift_args
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