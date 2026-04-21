class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "062a707dfda978a673fc59aca7da03541f27c8e172f1f591f5725767f25364b5"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbc623ee6afdc33c8c8eaf3ad0f7ce162b591d61e87b5fd4f4e48cc01d5f9cb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55672ebee8aebdf9d0a14b5f2baec18b21e7a16412ec8e4a9ad563d856772d13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a70e0724ed90668fee18e762a18b1cd62954e0a341734989fe02f6ee90e6f01a"
    sha256 cellar: :any_skip_relocation, sonoma:        "181759b9b6e46cc6b6015ffc0a25f4f300ab25d86740d653f3e0f5904744133b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49ea446cd09a5ab5506e78c85a49bf3e88a1d60603c229220ed4c9f71f882f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03cc7c85d966ea9946a130dc2c88645d955780affccb6c75dd2f735244568f8"
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