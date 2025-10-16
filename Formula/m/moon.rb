class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v1.41.5.tar.gz"
  sha256 "c0bee174b964b98098fa3dd718e0844893d63250f7f540920d5b33fdadd82712"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f5dadd0eaab1c97cc400235507bf87dd696dcee1580f2d0252dbe68f6487252"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "514bb215a6a55f8a946186c652b525511d431b59e606bf81ccb7ea9183b43616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "690a1a3b828f06b321d781df5062bdc6e7974ff4af464a2cf1bf334d2b609cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e3462805b48bf67a95be6a623d06e6b9b89fd54369fe5bfdc100e7db3b284bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0850eecebf04e329a6c70b7dff12b6ac52dd804b6c768f420dff0ba2d609544d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e365d8032434edfc293e5112be933ddba5d92ebc15149f510b0f46500178667d"
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