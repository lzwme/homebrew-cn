class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.8.8.tar.gz"
  sha256 "46b004bac4d67f25f93db821efedd85c0d649c45f56f2a3e359a596ba2cfcdb0"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "d53ee524651c3e9b693bd5e1daff2b2adbeda84b33bf8a38b6dfb15fd2444c12"
    sha256                               arm64_sequoia: "ecb2bb3437afdc261f46f249377a429cd93748cfc3b614bfc1bc418fd652aca5"
    sha256                               arm64_sonoma:  "4adc2e3cca157e31ff306df5c49624acbb2c291be2df39fa2c4b7a9f1b433966"
    sha256 cellar: :any_skip_relocation, sonoma:        "27939767b34356917e8076e0f38de4381970b07781c6a7964823ab869e020507"
    sha256                               arm64_linux:   "83d34ba2081ca4d71112ba19f7bec1c8b044b31692b8b92237c7a97fa0dce481"
    sha256                               x86_64_linux:  "43afe852e013882c0ffb06073b9ca22e7f0d403ed5310ec083a0965db9060e9a"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.8.8.tar.gz"
    sha256 "7decd9034a0a2db94e83b177ffa7e3518d6ba04bef0730abc0317c766207c897"

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