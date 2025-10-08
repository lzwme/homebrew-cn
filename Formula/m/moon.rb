class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.41.3.tar.gz"
  sha256 "5e5eb916203672fe22e5584a8ff3c3b139fde1835694d2558937473826f94f0d"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53e2ef34a961bfa8db520c3c4f7d3b06dbe8e7a455e3b2faadb8eaa8f323f24b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "401ff9fc785d03d9ca09aaeb23bee84c5c8e6195677f8be9a71c97647bf8a879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a937b385d3427a213035d64b0bb96763db51637b717941d11347ff9483662b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f376669f636ad79a30875f07448495f44d6a9fb443b8b0237edd3d8faa7abfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c0816ceb96321334ec79b11d460ecaf6f1ba3dcf792285451e048a4a5c9db4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2216fdfe9d895fae6fb2a5c56b747c07fe2706af73a67351d7e7ec44a488c71f"
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