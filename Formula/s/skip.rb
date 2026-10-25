class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.19.tar.gz"
  sha256 "87e2531b8d7818b2afcf752485675b4e22e80b5d7f646f37ac73542af8855abc"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "581d2e99fb397c40df6100ad981450954a1600eedcb14d9d44e3149ef8ddf566"
    sha256 arm64_tahoe:       "7397c8014f1965b6a767f66cba2466967522dc7ea0dbf20d1d414f7b437c5fc7"
    sha256 arm64_sequoia:     "3d9e0e7506349b67727502e7137e1d8dcd824ff198f1eed16d3af3e22753104e"
    sha256 arm64_linux:       "69aed3e46bbe2e2b07c7ee1fac9f189320adcba1c80bfb4d7cb49e3273a89d29"
    sha256 x86_64_linux:      "40bf238eda5b520980d32f95ac1382387aa39b33845acabf09ec74b0b7368433"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.19.tar.gz"
    sha256 "820ec8a3c8aeb20c7f1b2081e66ca8eae1d4cffc27e0469c8574754b27dfb94d"

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