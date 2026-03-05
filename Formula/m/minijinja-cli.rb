class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://ghfast.top/https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.17.1.tar.gz"
  sha256 "917d7cc981ed1615d735570ef813c70825567b78ed7345925b56dc7f12fd218e"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8d83d5a52c756a8321857672951ea6878eb06867c1681c549ddf863801d8fc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab07eee60d59f2f34e1049f8655d2b3afebbe22720eefd68b0816fdf67635645"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e32ca3d7d14381ace03ce68a39fb725cbae7680eb13d19007b6bf6b3cb7d37"
    sha256 cellar: :any_skip_relocation, sonoma:        "59961e269021576edeab0ac83dcac06244add5f71a88c637befed90e5942aee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faddbabef2ee53c128ff4ae06ff08e47322d50b74f0e1f31a11d3f6fa91ff589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9304848f3a1526c0f5ff4efe73ef818edb01bd94c1e6cb7e3d314724557a3ac3"
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