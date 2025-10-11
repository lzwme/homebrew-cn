class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.41.4.tar.gz"
  sha256 "1f6be722e186c5359b238925a8db8620fdb1af88593e537c7f26cb75eae2139a"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e14ff4a00b0eb6b092df490d01965954eda11bfc7635888d4076e899adaee895"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0e4ddb68c3de89fd96bc9ca566cbff8684db8b04f6209995c77920c3e105a0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c988d1f4e79aac11bf42b9a792d850922e3cec708c4a4e96f20205b059727104"
    sha256 cellar: :any_skip_relocation, sonoma:        "92c1e2b4c43777fbe86bf2eb88fbb4c601b65a655262f6868e71d6e92655c664"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "967aa7b71cb4a99c9fa9b6b24171f2cc8c5ce08727862bf3fcc89db48f3bbfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22bf414c5d82857144a98ef976b7c29c00ab4121a9bbca543d7aaa9d71e5e07d"
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