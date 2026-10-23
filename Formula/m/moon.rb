class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "11536a5c4d1f3a1f95ba35ae319cb4590cc912ff24bfe785ccca5eb22984fbcd"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c12ef85e983a1962ecc5fcda7ae91aebe5ef77e0f62e8afde794bc5e1669ba3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c5d59c6296ede84a0728a758d343826496685ff31ec5c169821f1a61e627e91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8130827e7504c29c11691acb2411dd416371b51dd176a6cc39506972d202d64d"
    sha256 cellar: :any,                 arm64_linux:       "49ea8446c128c508eb0072d711fe02fd15b31b74d1a32e0a5a4c61e2d2256cfb"
    sha256 cellar: :any,                 x86_64_linux:      "5452f8ba89f322dbbec277086237c9fcfa72e2699663192a9f458ade2f6805f5"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
    assert_path_exists testpath/".moon/workspace.yml"
  end
end