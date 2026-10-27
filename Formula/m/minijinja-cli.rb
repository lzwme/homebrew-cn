class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://ghfast.top/https://github.com/mitsuhiko/minijinja/archive/refs/tags/3.0.4.tar.gz"
  sha256 "c200618aee830aeee4581a6fd92232ccd248d7371170339553caa19733bfc1c4"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87f69b49262a0c12af7ef4882c3fa86d20f58153a5d87b094cc589ddda4473ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64dfa673e0f9a40cbde246f97d487d3c8df064a98f48140ee3a2a064da05b4c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94956315e0ef1d45b8f4456636763c3e20d468f02be60fce59fe19b2a725c74c"
    sha256 cellar: :any,                 arm64_linux:       "a99eadb022b54a814b715a464e603bff7e7296361278f5bcd4469b921162970c"
    sha256 cellar: :any,                 x86_64_linux:      "1419f4e0be306ee23ea084a53812450d024e687b36d4710ff733d96ed9012db3"
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