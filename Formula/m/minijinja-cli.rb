class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://ghfast.top/https://github.com/mitsuhiko/minijinja/archive/refs/tags/3.0.0.tar.gz"
  sha256 "cc883891ce62391fa1dc86fe0e17ecda86f5cbda88d904db91497e316f445ac0"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "872d8ddd8a6034a3dfb6b6772fdd54132abba57c6c58e0fcea3ed835181111c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a080a8e31f23f4f06c3738ca03a734929d092a6fbf7c279e0c48bd9bcffe7892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79848047881c98d3613891d26d860ec96b3acfe8ba20e3de49e20c12eabdf055"
    sha256 cellar: :any,                 arm64_linux:       "0064baefb52b9ea7aced5a4da29ad13290eb37b6ed9cad61b5454cdd05901cab"
    sha256 cellar: :any,                 x86_64_linux:      "dbdb823784774c93922aa02c301a738cab6555e5d04dae26c6810f683c552fe8"
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