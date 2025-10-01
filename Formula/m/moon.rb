class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "22e4dbee614ecde8ecbe5241db9c2ca58f2aec28ef7e8fc9211fdaee400b6de7"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50e3769a65049bc161412cefc6f7fcb060ada5a978c34a76329c77d989ac10c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aff34f7a0d361bd0f87d27b828979d788135f64d1f204d7d46ec5070b63bd43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb1a0ec4612b6a6f6852da50d864c976d9a3ff03707e2d22bca58f3271040f9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa88f74f766d99debc52550b7359b17752e6e7757bba8008e1471da17528568d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c6a9993022b5abbb0af61e5a827225ee6e38ce6eda394d867f9028a35cae693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24bdd1a038b1217d048c409c08e42b7d7e4ebd3dee158ecb2d19854ab2f7bde4"
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