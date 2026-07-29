class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.4.6.tar.gz"
  sha256 "31825024f63d4ac3b7d9f70415b4f9846781e7de41d9fca7f1dac06ae51afa05"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d02a2ed3a3a94e78c6087bcae785d600069c153b7deec5383a0e47f6a9679349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f16033d0e00f32370fb339dd12d7d89251ce9187523b8855e8e662291dcbfb71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4947d2af16287082976b46ec515c084857bd8f07f2ea6f68869f016759c4e18"
    sha256 cellar: :any_skip_relocation, sonoma:        "79d66ec27f6fa3c6068f132c95d66cf6d9b6a440570bdf39ddeee2931d9d8fc4"
    sha256 cellar: :any,                 arm64_linux:   "39b844ef4f400135c30550fff4c83a252c765c410ce272d7ce99949331e5c951"
    sha256 cellar: :any,                 x86_64_linux:  "16c3bdc0ac5159787fefe42779e98c1c54732b2096ed34eec0963a312ab6a73c"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
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
    assert_path_exists testpath/".moon/workspace.yml"
  end
end