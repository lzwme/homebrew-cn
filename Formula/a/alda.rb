class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://ghfast.top/https://github.com/alda-lang/alda/archive/refs/tags/release-2.4.5.tar.gz"
  sha256 "6c917d53631b2513c7ffefc0a1295046b40560cd5479c98699921bd56238dd07"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b15c5bc7eb600a7ee63f444115f61a0b6245b7bc450a5ebcf6a01023a8edae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee1c7664dbd9b692fe370c3f21eb26420fda2b1c149b333e0b8ca50ce2b0e80d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f24e18c228375c454de85c4e94e49f3428c2a8a82203ac472126a9a6d2abcee"
    sha256 cellar: :any_skip_relocation, sonoma:        "0573f2c6104ae07d3c34b7555e44daf5f9db80c76c1f40ead2240df6f46b97e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7d950cc3c9b80e4793a9c5ec6119fc97798817e3daeb8f77de3f136fbadc9f1"
    sha256 cellar: :any,                 x86_64_linux:  "45f41f4f1658731be2410f2eb63f8ce44006f5f908fe155eb956d1554c105cfc"
  end

  depends_on "go" => :build
  # Issue ref: https://github.com/alda-lang/alda/issues/510
  depends_on "gradle@8" => :build
  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    cd "client" do
      system "go", "generate"
      system "go", "build", *std_go_args
    end
    cd "player" do
      system "gradle", "build"
      libexec.install "build/libs/alda-player-fat.jar"
      bin.write_jar_script libexec/"alda-player-fat.jar", "alda-player"
    end

    generate_completions_from_executable(bin/"alda", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end