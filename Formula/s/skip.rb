class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.10.tar.gz"
  sha256 "440d4a9ac7ce2184001206d0121baebd79987412b59a084561c57158af0ce4c3"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "d8f999761a5120d19429e6d2426c45b6b42f0f64149011223fc4f6842f381663"
    sha256 arm64_tahoe:       "bea0d222b8ff7b614bcfca2def9433d4f6f94c287bfb34462d792e51f0d888a6"
    sha256 arm64_sequoia:     "0838f1023da66605625fb103922881c2a35dacd1d059c5386078b523b9e23e2e"
    sha256 arm64_linux:       "263ee17350b212de66e9a929253d1099b51793e5a6c55fccb4def1139bd93876"
    sha256 x86_64_linux:      "e189015d682d19a2366150518c8306d4ad832e2d979996f2148acd730a19f12b"
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