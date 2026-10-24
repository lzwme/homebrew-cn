class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.18.tar.gz"
  sha256 "f2cad2cab96d2db4c7c241280f7ee04177271c2738a35af3da8d5df6aa5d3445"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "856c7d7bfc0253046ae93ab84d675a4ed36a2276103571019af662bf85c28bcf"
    sha256 arm64_tahoe:       "8bc115338995188c3a2124d46bfd2e3ca53247ae54a5d3a0c37311c9e5bba8fd"
    sha256 arm64_sequoia:     "561c781b2ddf9ce7ef85c421397768dc369f55261de24c41ab4fcda6309abe6a"
    sha256 arm64_linux:       "0911103971c181cd8a2ff328e714a3284e2693c961072e6f533b9bdf07c9db30"
    sha256 x86_64_linux:      "89128e897f1cf0b88dba143f06428f0349632bc6acd1448919dea91aa7be24cc"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.18.tar.gz"
    sha256 "307536039cde604e557f068e904f7fbbcd71034758f2ec46357b3e56d03219b0"

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