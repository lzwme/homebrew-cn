class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://ghfast.top/https://github.com/mitsuhiko/minijinja/archive/refs/tags/3.0.2.tar.gz"
  sha256 "d9e92138e1e664bfdd04afec0c2e894454bad872c570a5398ba6fecbdf4e23f9"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0aa14cfe0f33842dc2204759ccb01eabf9db652756eb441aaa098a3157e2d4b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bacd79664d10a9d5dd43bc50ad9556f8532effe51a877ed23ebf3d7ff03a488b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ccae253205f7fed678dc60c2d4a27924414daf1eeb03a41f28307d7490a71cf"
    sha256 cellar: :any,                 arm64_linux:       "28fd0747c2a692d573684f317dbe0ed9f91652d6401bcea8168a1e053ad8681a"
    sha256 cellar: :any,                 x86_64_linux:      "9d4ce16dc3626a58a0aaf82d626cf48a57110cfc607ff978088366a49c3bf9c1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~JINJA
      Hello {{ name }}
    JINJA

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end