class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "9210d5a736b6b267c78826481f903e17840757d4886b965266bc3c936bdc3f75"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cea5f333e23edc4266d9c65ff348023100fb074d2aa0d1ad489adaaae9b35b05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7734879d97f4d4a5a461e157801e1fae7baa2c372bf511c0bfa6e2736189fa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7f84f88b0b25b6cc5b3341d9b5f57c99cd9032f1285bcc0278779c4f1575329"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f442f037a25fb2a187bb62a9e95f8c9a2569be3f7a3e1df60703afb728ba41"
    sha256 cellar: :any,                 arm64_linux:   "e6424cc2559cf4cab3cdadb6d1b69518ef0499b07e2f38bf7df23888f7909beb"
    sha256 cellar: :any,                 x86_64_linux:  "fb62710ec50d52277a641f217029cd06441e39f32d667e2c751dc86156a9bbf5"
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