class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "4ffeee5c40fecb1d28e28330f4841c7985a8c5c643d40635b1829812ac235f67"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f3481fb01617d8cedd4bd90baad531e09ed552c243cd17a7de5b68043801c8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d35bcd78496109fecb387cfcde4b57021f8114a7c7f8b5153a7cfec8f64a864b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0891d380497b2b222de17cd897a9aeee64548632c2c1552ccbbddc60f0894c6"
    sha256 cellar: :any,                 arm64_linux:       "140b8824a22f6cfe457e680230d6314afca1551ef532cdbb399474a5a481791d"
    sha256 cellar: :any,                 x86_64_linux:      "f8398b87c01673f08d0af0a2dbab56215028e10c5090a88e60fd3b9c4a7ac4b7"
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