class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "40623a2a2c2190dfd85cae6ec933ccea29958f6b4838d2566e5abfc443980ef7"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d2ed586dc43a4e73f60d5b85dd7bad30ff4f5e69762170690154d7500a7879b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdb1308d7182da21bd92937bb28440bacae72e38636c43a1a43ed6b60201af2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f80958a977fd54983d3a96148eb3f74972084b6711390b12ed04692af6f16d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8821b5b86a3cf7365057560b7ee13244016e608312d13acbcde21e1ab4c7f338"
    sha256 cellar: :any,                 arm64_linux:   "551e1b698187719e254d877b5f8e6683cface44770ec62c5c0b9b05c167d7a14"
    sha256 cellar: :any,                 x86_64_linux:  "7f5b2a331ba433037e684e8d1d2ffffabcef395c25f2b13c5c55a45e8d6026d5"
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