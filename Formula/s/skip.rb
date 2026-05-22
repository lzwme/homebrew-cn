class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.8.17.tar.gz"
  sha256 "80a78804b31a4e03f09af870704e1f31919e0fa7ab68d021c31676071f0cbee2"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "bf835f0c85e66f8c30ce123ae925f7669488e64409a432d19e2d9d5af5cfffab"
    sha256                               arm64_sequoia: "af874c45e5c87456049880e88865d89745d19910b34e46b643e7638db835d704"
    sha256                               arm64_sonoma:  "111bd46d4bb459fa106b27cb465dc27fdf442d0d2efbeee1f606a9f9266db0e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d988b1fcc9fc57f548fe55b309b0938f4b629f629414078c3990d9de273f3dd2"
    sha256                               arm64_linux:   "1164c68117b4e24f88310b081fd62d32367d9c441fd41f20a2f268be8c2702f6"
    sha256                               x86_64_linux:  "de5359dcdcd8c3352c01574eaf8511fd032f898fc4edab72dcb5c5aa08430f6c"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.8.17.tar.gz"
    sha256 "15baecbb0245144fb020a15ac81917dda10b19f3ef7dcda71bb54b3d560b208e"

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