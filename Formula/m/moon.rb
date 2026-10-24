class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "c1063b9aeac175e007126c3a6b86b839de766a0a8b0fc02a908075f9b6c2eb5e"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb5808591aa2cdebcdf7adf86b94af42cc1705d05034f4310dec06c7330f74a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfed90c01e274f22a705f99bc28f43db3a61464927741facf2ba568d518c316b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6efba6a431cb458ce4d49d9a864023acbaf1b583ed6e80406c8c1799ffd13221"
    sha256 cellar: :any,                 arm64_linux:       "1736dd962ac61b460b95fd6b1790a8fd58e1e7c2aa83099593a26660358c7e74"
    sha256 cellar: :any,                 x86_64_linux:      "26ed28b6ec13442a2e5d1c98d9a208c0204aecdad3b781bb93f4eb671d15f338"
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