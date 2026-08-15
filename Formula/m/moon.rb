class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://ghfast.top/https://github.com/moonrepo/moon/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "bf8264c16cf9489a5e4ab80324a1c60cccf63dc16389340dc3ff4b8cf08ccbfe"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42c4d85f995fcacc9f3355f3c48f87dee19f448df52e9b6de0b9fcdf2fc6d1dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7e9de68a67e8f9bd1836858f02ec4971d9ce48ec8e5e554da0a9f999c03e6a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4da58acf33cd291d0647b167c01a4393e0a0ea32ec33a1e355d12e475a87e9f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "becb062b2345a6b24d412fc146e259a00e4796074e6b046c2e7d0ac6bcde3d6e"
    sha256 cellar: :any,                 arm64_linux:   "6efa806fa8e4bc1b6daf25694a0766dd8a43c23a60c34dbc92778721ffb55f05"
    sha256 cellar: :any,                 x86_64_linux:  "9c4aad33b86034a639f37c20c61930fb2385f8e84fb3316ba1c5f0e0146f54e5"
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