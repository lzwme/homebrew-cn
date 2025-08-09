class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.39.4.tar.gz"
  sha256 "20d4d16032ff0502c346a7772d3f623f1ba42b5d66f472ea03ab3f69eca042e5"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7052807e7fff1b75fd52936f59177deb469b01cdd8c28a8d04abdf289d8cce95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1ef6687a8aa92f4995adc8f5046a19c0cc4822133b8183520163cce0a40dc32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38f8f8960cd54e0d1abc606326f92077e4a3e8d05f8e5a176376871ea32e0570"
    sha256 cellar: :any_skip_relocation, sonoma:        "37798249f2b7154d60239244688f9f1e9511436040c10eba5ec914db0197d3e4"
    sha256 cellar: :any_skip_relocation, ventura:       "0d97b25dbfabcbec2304a3001852fbc081b84555374dee24d5e204018394de7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c9ddcaa0a32231f13cb6b3a449a999803611457a9d839aa0a5d3d6e78125c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05122bb402cad1e913a5063e169245a754fc67090472e8c04b1ce4f40f6734d1"
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