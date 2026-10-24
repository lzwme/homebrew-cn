class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://ghfast.top/https://github.com/mitsuhiko/minijinja/archive/refs/tags/3.0.3.tar.gz"
  sha256 "52491b3979c54ef76377b08f1e560775b197730a84a48ee8abd08746e7bd0f6a"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c6c7779e3f057f049c7f1b1bc6cacafb2e1987f9a83094bef12fa4c12e63b35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0e41603d1d5c11aed1b95f936fdf7f2bba34b9cb323fa787b7c11e5808af190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d40cb6bb2515733ffe620cfc8edc6f7bc61fa7af06519ab2f037a5dc096ece9f"
    sha256 cellar: :any,                 arm64_linux:       "d60cc507baccf8eabb9c79697346c86274ce7ab952524fb182c0484fc53e2590"
    sha256 cellar: :any,                 x86_64_linux:      "afd5aecec3f75a5d5fbc0e755a67cea1fb4a5f3777ab20e788c37a11815e3c36"
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