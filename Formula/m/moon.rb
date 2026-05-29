class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "6f8a5deafb74a7bc3162e4546093969b8a9f98e424fc3baea0fa165729a31f2a"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f504401a97c62e68211bdc46f01f79e02cd2e129a05cad26ba5f8f46f9105c12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5aeadd1012fae39fa4aa1a26ed5d632642241a36bac551d3b320966ef01441d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f30bf8cc1a8bc60578eab3cad3d2bfdd3e425b6fb43bb4d72f9e4e63f2e0391"
    sha256 cellar: :any_skip_relocation, sonoma:        "879041b309bea72ea9bb7d415ffaf4cf5a719410b654c76dd022fb0c9986cee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd954be2fad9691cc4b048fef6f305e213f7be485474c8267c09302b8aa4fdf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05a9764db2f861589bdfaa3ee3535d82b763ce6fb94402269c0924e68fa8a62c"
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