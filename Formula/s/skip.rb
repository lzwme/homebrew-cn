class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.10.tar.gz"
  sha256 "440d4a9ac7ce2184001206d0121baebd79987412b59a084561c57158af0ce4c3"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "c86579f9e3bc9435d3d171f74623d6e18914db9dd21fbf82ef30cffd6883dcc5"
    sha256 arm64_tahoe:       "d9907b253aaeb6e0124ed5d98c427ff100cff5a08ba47071d280f37508c122ff"
    sha256 arm64_sequoia:     "1b90d7ddfcdd8d20f90d06e0a20b2d239e77c0ca5bf5fa0061206bfabc7d3e15"
    sha256 arm64_linux:       "7750a533c47335e667320b420ec5bf04cf75f73dd9df52c279197f80cbdfb172"
    sha256 x86_64_linux:      "15f5cae8b62b0991b142813de70be63190882bc04fc31ca84d48e18de672bede"
  end

  depends_on "gradle"
  # TODO: Switch back to `openjdk` together with `gradle`, which runs on `openjdk@25`
  # until Gradle supports JDK 27; mixing both in one dependency tree fails `brew audit`.
  depends_on "openjdk@25"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.10.tar.gz"
    sha256 "2f9b0b50038ed5f088e6caca005639bcd35f5a76e78255241d79541ca030dcb2"

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