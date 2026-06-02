class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "178555131e8e352a97ea53dbf09e691939b4232a0396a019693115b49ad4be1e"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12224c5d3278f30d3893794251f31e74a34fadce87b3fbc005a2a2e51a36b6ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b570c16b67c6088f434590bf4a1d42bd9a7643b6f957032d57108da25c27c63d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dbc9aae9d5e262f61ee9a3807d1dde8cae3cf0297d48ad6191a5cc6c19682eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "80a4ba1f311a56f7f68a26c1008273f48fd9d7ccc0c525a164967e4938443fc5"
    sha256 cellar: :any,                 arm64_linux:   "d314befd8e3fb8bb5d79f5bfbabc0d8cc6bd8fdbb17442c4235f352859faca4e"
    sha256 cellar: :any,                 x86_64_linux:  "0b65ba75e62f7f0edb30be67afd3d1de37b9ef2e966ff2c143c69596bc7e6577"
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