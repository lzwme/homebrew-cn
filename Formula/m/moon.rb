class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "fabfda01694bba2730f9a658b668a0d6e4fd7067086916728a445bf80fa7ed86"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "157804d4fb259f30943a1a94b51e68637f7a130fac855f0729cc6e19c5e49bb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3e0a2b4fde08eb2ff2c0e3d2c722615b6622dc4786a6d40ca8d4f5ff6929555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f41edf385d61963de76b369260fb38a9817fc7c5b5a7003c6e65827392820ffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "05c304975d03c1af2b01616f96a658bd90ffc7988b00bb1c6571554007d6a536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31102a2c0a075cb20ddd026b76b416a6a5eac86e16f40698de4355e79d24d572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1fd2c873cda6b75e4c1a4754e78bd9835ec636710604d5c0c4e4d0f3b922cd7"
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
    assert_path_exists testpath/".moon/workspace.yml"
  end
end