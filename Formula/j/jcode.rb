class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.98.1.tar.gz"
  sha256 "271b1f9c38aa1e439b1fb9c0cebff443c8747f34bdf8976b18d8f967ba819641"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "108261e9d062ba7380b0ee52f889713b95606259c2c13839d37b120b24f2f524"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5f860c7627a4a3e643d4240ca0a7ddc6c85fea8d49f2a2c3ebe3ae304794027"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55e737aabac26f6c49ba99b3c168ea0f605ea9b7110f3ffe63fd3137b238fbf6"
    sha256 cellar: :any,                 arm64_linux:       "2e0f554bc027c66cb08b15a183dbb3daeed057d3659353e750baa026c2e24ac9"
    sha256 cellar: :any,                 x86_64_linux:      "254146ba0aad5763d2c17e1cede76d1718e59889eb48b702ad73f1e5153a4a67"
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