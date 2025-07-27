class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.39.2.tar.gz"
  sha256 "b9d14c824c2bd32aed8744907c6dace4671b79cf758473e6d0b1b5f6ddf25764"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a6dc866817a2eb5bfb9ef9a43ff02bab9a900d6e4deacc69e3d90164b1eeab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "400a528e8b477e73891c8c1008aaea0b4033912e2f070c7844ab7d194d365ddd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67afc27330814ec5439924d86a0612ed50b8a4dbee663409228c4ec709743e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "e892993904b08d234e5d861cbbe98aaa227ff1c962a34d8fbd06978c494848cc"
    sha256 cellar: :any_skip_relocation, ventura:       "a87583d7f02a5cc7466eb17c0a8f60a19fb6368202c6dcb55fbed23ac63a04e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a9e407791285286c0da76784e92a298daae0aba10c39461ceac50a6d5f80298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b82f229f0f6494653a649a84c56d7d861764314bdaf99e0c291e500cceb9758a"
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