class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://ghfast.top/https://github.com/alda-lang/alda/archive/refs/tags/release-2.3.4.tar.gz"
  sha256 "b4d3c8d4f917fc3c7a0e828936d8014035189ab6324188f39d52360f0ddaccf7"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc6a99499ddd1fb0046f55e715ec4fd8e1d9eaf1c5503aa4f947d6a5ded92cf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a98e3ebd579919c1875f51ac73ea3209d9b011eb950bc96e4980aba7ecf7204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb1bf3a0dd9662d81e4d98d569c73594250e769e7d88a9fc832607f7596739fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1eaa07d1f4e5ba320b9e5e873d9464eb6ae9c8118bb101db9764e589983c4ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33121f0c8a958315f0de5cd8f6e545a9c90ee667d38fe0f4bcdaa70b544ebcbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2371a2ff940c16b4a08faee23f79dbd0cf7df4c2477d10274fbac68be4e543fe"
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
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end