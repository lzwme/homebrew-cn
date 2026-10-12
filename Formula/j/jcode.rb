class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.95.0.tar.gz"
  sha256 "5cd47d75426481523d497fdfbcc9e2c605af0dde8e5ea83c6e4ea03c5f6f0302"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd10664fd1e1646ee21e4e48d3d51c5c9a8bc584b697b4ee095dee15ceda8278"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d72616224c7bb6930e375cb207f5c72f81da04d02e010322f6a63f877ccaa70f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c2bc30b5ba56c238e9a83482b24914a74bf8a6c97e398b40a4693216a7f8554"
    sha256 cellar: :any,                 arm64_linux:       "84378e637f03ed82228c9b49a4a55701d248d062e3eb39a21645f88a9dd96f50"
    sha256 cellar: :any,                 x86_64_linux:      "d8b533d2900f0efc0f81847fc29fb4f91580b1d12985b3bf3759c3568da5193c"
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