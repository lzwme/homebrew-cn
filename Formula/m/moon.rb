class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "b98c4d1385c7adc6a87de5292f36f27893ae596b630c7d8cee8b9b0a1f4fa9b0"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0e1b2097527c201ac97f85740add09acb6d645caf2d17aa18450d12ffa297e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "154015a861778090938e80e66a54ff01ce18c13cd920ceb36ac06a77f08fe39d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f70c2df0dd554e4fa637c4bdbbcf194f829eb736de59fbaf61c39b479d2307b"
    sha256 cellar: :any_skip_relocation, sonoma:        "16557ecf38945b853e992bd639662ac74d6556fd4f8bf9f0d79faf6b7cf917ff"
    sha256 cellar: :any,                 arm64_linux:   "c1650f27866c8fc7e8271f0a4aaaf298583758032e5d938b1a92d327f7b66ee1"
    sha256 cellar: :any,                 x86_64_linux:  "66499dad7a6627a5ceb25b007564cd1ca3fa4a32694bd0d8eb61b7bc48b98ea0"
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