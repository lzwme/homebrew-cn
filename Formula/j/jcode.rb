class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.91.0.tar.gz"
  sha256 "3579db399c3eb1e7f342e2ccb599a4a34d5b6f193f2338693dc7cea831760c71"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d87db13026e1ae56b4762f2d3d2e02c1c73bc9882868a354da5bb6ce354ba3ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b39a848cf00d71d2757dc15d1ccb7f756cdc25f85909b0620c3d835229ea0cac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8898bb432afa775bcce6c58dd5f8ef57e6adb33353f44d9d893ec40c00e1aed"
    sha256 cellar: :any,                 arm64_linux:       "a3c00df64bb0dc2ae24777cdd37d9316d3e24a50c811045f522ffad293e7736c"
    sha256 cellar: :any,                 x86_64_linux:      "6371a89444c8e120f8fc09e38fd039f66defa3528bd754cb12d91a3cb282547e"
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