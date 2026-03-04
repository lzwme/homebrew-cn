class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://ghfast.top/https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.17.0.tar.gz"
  sha256 "33bdf1d6fc5c33b9664cf14d97289ae79d1c0fb9c9f93293cf38d3c71bcaa4f8"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f41364074758f511125a52646cd4cb5d0af9ffe1d871e5344c454b716b9e2a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d816462eff471792cde7c73d6adbf497658eebcb22cfa8ba48211fefcd4c85c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b2b8df0c53ca2b870d1b09e0b1eafe80a017d04541ce90a8951b34139d01a73"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc8f390986fc8e27b12a27d29178f07f5780e752d38a8ac122bda2a8cc28f366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d468912fa5c3f6cd1af567adc6c250ba26f31caede1761da789127bcfe2021f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "869aa0cbd64ed6e5ec848c2966597964e0e709ba8351db784ede52c0b476e87c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end