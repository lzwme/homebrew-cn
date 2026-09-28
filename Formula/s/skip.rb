class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.11.tar.gz"
  sha256 "da5280142a7537ad4424e6b420128d01edc24a0be6e654b60f8f44f56ffb4a85"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "aa75eaa2de8c356ffd63aa1d1201295e56200f8186a7f3ca32e7c2019b56745f"
    sha256 arm64_tahoe:       "8d8461bd18684d07ab42382fd6179b51beb2aae63e6e453c03b08a3d16c8c744"
    sha256 arm64_sequoia:     "2f09995b647ebfcd9eca162abd041951a4d36aee82e3a6ccccdb3c75cbfb3306"
    sha256 arm64_linux:       "364eff7c5182923fa44d1a12b40bfc349d0f579db053f2cc082a8fae0da42771"
    sha256 x86_64_linux:      "1cf0f543d1285c02b1664be8580b1ed3864fdeacfe85bf7aa72f19e2dab4d78d"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.11.tar.gz"
    sha256 "ac55fb432f02460df5acba18f3ad814be9d2cb970b38ad0917ff7ad010acd8c7"

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