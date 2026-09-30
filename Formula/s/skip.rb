class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.12.tar.gz"
  sha256 "2db83a0ef2be3483a49b6b8a46458851cae10077423bb86ea6e26d0038ab784b"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "8ec9dc64b958c9df0ff623d885ec21c8ac1613ec67b30b439c4dad9e5729bf5e"
    sha256 arm64_tahoe:       "62e6922cbcc598d6ed553406476485865929ea2fe7cf2c71cd723e4552dc3d83"
    sha256 arm64_sequoia:     "861682156d902c4c9b6e674fb599e17347b94b01b975bcd1b67fcb95632e9660"
    sha256 arm64_linux:       "72bde03291459becdb0d8d12377bb49e882d3d8c7fda3af69c99fb87b5a1969e"
    sha256 x86_64_linux:      "ced1efcbbd2879062bd406b9e4dd0dcde44bf2ab3c00d58892aca180d1ebc18d"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.12.tar.gz"
    sha256 "7870592a199c2aca5e9efda496503bddf1a8daa1defc4a372576e4d43380cd99"

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