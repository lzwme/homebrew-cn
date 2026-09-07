class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "fbab8b02316c436eae162d8d7dc26c029435b24e6205ceef5e8d310f2d0dc7b8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e82e29ce33c027f6196c6127c54267edea09b3a511564741c458efab872068ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11ce9f8976aaf31ccc13f8e206e23b2ca3b8c8487f2ed16657808920c2cc049d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96ea704fc2e5502ebad0ff591b82b66786901609e679114b8ffab4407c990bae"
    sha256 cellar: :any,                 arm64_linux:   "0bf32f66314813d11f079d14e085963cc5875af593dec1a66b6f44eea202591a"
    sha256 cellar: :any,                 x86_64_linux:  "d19b487d37b34c829f681920cfeb8ec6cca1c90844f9487d84e442eb91486ce0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access! :build

  def fetch
    system "cargo", "fetch", "--locked"
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