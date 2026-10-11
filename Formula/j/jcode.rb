class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.94.0.tar.gz"
  sha256 "2ec8d61cd75e716b28ef593bf05f3838a9d89b5bd7a92d394e35a6d4d73ac575"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00b112efc990b0de5fabf33ecf64ce75745409a9dd0b02640477f9753be22f22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c468382a572ba604425fe8686e8287af3bdc0b30d7661eb26e73a398a0e7f41a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02f8ace1ae032215d2d8a488c6d7eeca4df9994a56ee922d0982c564ccb836b9"
    sha256 cellar: :any,                 arm64_linux:       "fc3258aba9d11351f1edc479857151a9edb8921f62beda2e43bc771d7df839fc"
    sha256 cellar: :any,                 x86_64_linux:      "bec20cb8a0d60a1088b2dd59bb0d8ae311e55beab4976c06e18e57c0a8bc1a8a"
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