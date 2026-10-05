class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.90.1.tar.gz"
  sha256 "8d5f72d773ed097b4c715ccef03e0d8011f7a4ab4e01d0597e49551935104431"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8fe3e7e1db05e05f11df488ffaa0d197fb7c26c34211252113effffa7d0d57a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ddb9b2176aaa0d8fb4cd60773183e3d297e07c0701ebe659062d9dfc5601b3e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd7a0dd50b8c5f4f7d7593c4e4d8f6b5f0e0a59f27b9ec1532330aaf2b9b2e38"
    sha256 cellar: :any,                 arm64_linux:       "2c09e66d2d51b3f201538aea59af3cddcc693f868e315f2552823c121949e117"
    sha256 cellar: :any,                 x86_64_linux:      "9a3976625072007363dbca88dc5aaf82f1cc54d8fb30501f8e2dec2e39dc4be6"
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