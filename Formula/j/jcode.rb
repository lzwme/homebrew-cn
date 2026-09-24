class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.88.0.tar.gz"
  sha256 "967e5a825f29b1ed3ab9649fe55966545ba4eba8e0d44e2897b015d2ada43b96"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "193694aaf3f762740ea0fe648d3984851de5d6d55e0854020e7da195551b3b23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "305fb1319999d2954b3c0a8d10d63f856ac061a2ad74d2efb28eb58609b725cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c0f0f1b1c32b8fc55b2e0894619ae5c1c324ca4b5e80fcad9772bd2abfc9146"
    sha256 cellar: :any,                 arm64_linux:       "c5430b1f6ed8a7214bd6d871ca79e25543be6e34040129c7f1b98fba766a8dbf"
    sha256 cellar: :any,                 x86_64_linux:      "656fad0ee8cf31a302335f60ae648b41a7ba81bfa7c73827c63b9c675a26eb1e"
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