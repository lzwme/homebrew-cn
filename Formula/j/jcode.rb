class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.89.0.tar.gz"
  sha256 "32a7a66528c9be9c66ec72e2465d99dced07f9769032278c4ede0b6297a64191"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "061a851fcd2b0a26a9e1d92d0777f58aca5ef04fe21dd0cbe1f8bb6876ebca32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7667b80bcdf3e9e256291ba8744f3599d0b0e33ff90e61cfd3083dcbe252941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87a025abeea6452dace859142f26b6db54793d4c36418f5db04bd71e343bce83"
    sha256 cellar: :any,                 arm64_linux:       "449bab49345942a5b52e3f0e431efa78500f5e88305b28f22b175751092fd7db"
    sha256 cellar: :any,                 x86_64_linux:      "f581ad45b29da770bf33cc597916bf6c08dce831fa570be351d8d18eb8efe883"
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