class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.5.5.tar.gz"
  sha256 "7d9fa3040bfa76a54d8d23e73427bd055cc54751a0dfb789179c1e68c0a1612b"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d06b3b5fa189b0f956363103e261cefe788e20b572748ecea3bdeb235461d1e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "106a55daba98ebade4d0e09619599438b0fc9ba5d04f34b5fc9f8bdaad0cf8bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a54a30bd4524b51403f206dced83805c51a35b5009bd4ecf2fbf49d8e113ce86"
    sha256 cellar: :any,                 arm64_linux:       "d49b0d96e28ee7a9cdd2bc908bad8bf7de9584d3b17154ce01d37b3c62dbce65"
    sha256 cellar: :any,                 x86_64_linux:      "07cd16c6647b5659e45889eb0fa500bdcd7fb16a0d6aa0796ee949929d0d2e11"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
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