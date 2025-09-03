class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "d9422f60aa28061e2833ad85ed7b35542826ad64395613cb0c46c000cbdc9842"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "566cba57972c0aa158357e87b71fd33c156532247202c61abca37a3321f7e867"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "623f86bf83b53e5e9295d2d5e66af5ea32e943e69c1892260908c4d80e2e6c42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da81540c7ea0556b85db9ab00ed6e059fd63094337639ca7dad359a628e53de1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b63b6c4445f067554c8a04ee30360fa858207c66e6eb517823e47f0757dbc630"
    sha256 cellar: :any_skip_relocation, ventura:       "cf3f83a812169e7755ca30795ead6ac4c2ed29b1d3b2131041d133b856a34a5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5acef45b760ce57b5cf9e4176c0836ea56c77cb3fe27c282960790deda4dff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e63abc85eb6154ab86d70d86f9604e0e3635880695c83150942091415649f1e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moon --version")

    system bin/"moon", "init", "--minimal", "--yes", "--force"
    assert_path_exists testpath/".moon/id"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end