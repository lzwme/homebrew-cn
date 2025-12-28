class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://ghfast.top/https://github.com/alda-lang/alda/archive/refs/tags/release-2.4.0.tar.gz"
  sha256 "d2056fcab1d61d0abc17cd44d49ce8d9cb4c7e7c11c8f6ddb4cddfff8e4a60b6"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39bcbff7df93e950b241a53dcc5b205136a3008235229f3a421b015c3613e775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c22e038c5f94f4900ff2b72573fe4e21a45fcdceea300a8030773ddec1e858fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dfc9aa9ee2f0ec5c62ca833071ca2267a98dab526ea6fc2d19c4cd4754f66f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "857834ffcebecaf7030f3b7631382d42c000aa20a6c5f6337591a8e0180491a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a9878b7517b961c39e06034112331d19c9f4d68e73670426de716b24af7e659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6bdb2862271b39c7485694f111b6811b8dbbb23774170c6daa970993fdc14aa"
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