class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.89.3.tar.gz"
  sha256 "8bdee5512ee787a2f33a17e9e3677cbe6b94e286ae44b8b97a70e01cef0fd3dc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "930f170629d74b597af69345aa1482487132c041f83ea93d5f9584aedcf03ad5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "717caae5a7825c9e8bb59fbf0310107da2a153d9bf805885794f40fdd7907d1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e486d1fe4931ec0033b135cd11e1258a534e0e97a8c80a51ada38380f73a021"
    sha256 cellar: :any,                 arm64_linux:       "c0047268c96242c9aa6392f2018a087e82d19047434f5d00c9c5761efed2b5f1"
    sha256 cellar: :any,                 x86_64_linux:      "f15b8019cb8da1575d440c760bf6ae035469a76669def0ad69fe4f82a38b8eb4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access! :build

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update()?;",
              'eprintln!("Please update jcode using: brew upgrade jcode");'

    system "cargo", "install", *std_cargo_args
    rm bin/"test_api"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcode --version")
    assert_match "Please update jcode using: brew upgrade jcode", shell_output("#{bin}/jcode update 2>&1")

    system bin/"jcode-harness", "--cwd", testpath
    assert_match "alpha2", (testpath/"sample.txt").read
  end
end