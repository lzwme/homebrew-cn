class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.84.0.tar.gz"
  sha256 "fdfc364d53989fe2b30f05f35844402decc813148caea1face4e7f588a671887"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0ee7d8f173765766dfc27257af21709e4cc6cb53408f9fe55dffe668d6184c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a63c85aa1ef41c3fb6a6811be4ce19e2a046b8ccfbd608d554956d9bcb3fcfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a35e51300e97998f6c029777424eebd2cb42d173d3e0340c8632cd43f1dc4b5c"
    sha256 cellar: :any,                 arm64_linux:   "bff571c064609ba862a76687451586a98d8a7136779195bce437902f3ef2a8de"
    sha256 cellar: :any,                 x86_64_linux:  "31c532275beebd7a6b958066b1b68b538c51d2575198ad083f9a5a035fbd78af"
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