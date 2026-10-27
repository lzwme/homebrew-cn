class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.20.tar.gz"
  sha256 "ebeaf9e73696a2d867a19df60660f6cd4f30b2c8f0da0ba7afb2fc167adce0ae"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "4de29b4744acf58cb43b3b616c5983fb7fa99f86e47c6bfafd1b3b023cdf1502"
    sha256 arm64_tahoe:       "3b79b64462fa66964fa40114eebc051c24da8d107b1a4933dc4961a47b458fe9"
    sha256 arm64_sequoia:     "b8cffac2cf6abf076d1d53a572006f14ee21c29be9b96fa148d5bb51c3e39bb9"
    sha256 arm64_linux:       "b9136ddc53471cd0aa5d0d10b1cfd013336c5830e68b2bc664fddeff64218a13"
    sha256 x86_64_linux:      "ba813641b37b3c29080a164690ba78ad7a01dfdbafe23b6dbe8c9d29730984d2"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.20.tar.gz"
    sha256 "f021fcc6766c65acbf120e8d739b706bc259085b6b21f6268ac8bf4ecb4b261c"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    # FIXME: need to update brew as Swift 6.4.0+ doesn't use ld shim anymore
    if OS.linux?
      args = ENV["HOMEBREW_LIBRARY_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-L#{it}"] } +
             ENV["HOMEBREW_RPATH_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-rpath", "-Xlinker", it] }
    end

    system "swift", "build", "--product", "SkipRunner", *args, *std_swift_args
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