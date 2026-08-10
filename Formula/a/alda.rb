class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://ghfast.top/https://github.com/alda-lang/alda/archive/refs/tags/release-2.4.4.tar.gz"
  sha256 "155fd3e7ca8082e3dc5f934e026502e9295b21f3f77f9922084bc221dbcbbd82"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "078defa06a017764b5d242fcfdf6918d72de858ea9eecb5bafd11132f4ba9666"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed9c65f6dc2f0d61a75253430d3137567e5c878cf0538ab3e2e1cf20bcdbef5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44e4561b2a304d85621ab6694ef48b7be7ca9dd3151249e838cdf19d321a1403"
    sha256 cellar: :any_skip_relocation, sonoma:        "b47643d8effead531a026381542faec2c4175e74b2e89c741e55ba436e5da973"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0799dafa7fb4c3888d176e52cc5dcc2434c4393ecba798d812e78491ea332020"
    sha256 cellar: :any,                 x86_64_linux:  "814b7b8b5841697a28c0d1a6b49a1c80d17c3912d5b98e669616ae328340e244"
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