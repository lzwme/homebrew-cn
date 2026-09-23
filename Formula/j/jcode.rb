class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.87.0.tar.gz"
  sha256 "075eb1335cc2fde18e1027c4a7f7f9fc37cb30df0bb94e60698f5e65ce0e9818"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "451a17ad57c34913715a612739eacabd5494818e4d8e0d1f76abd5d0321fbc29"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4defebd9fe73a43ede6767a1504a4f44c8d071d1c3586e87333c294bcf5f56f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89d62e74b05b24954bf2169361551c85f804ed7e4223e017d80284e5f024816e"
    sha256 cellar: :any,                 arm64_linux:       "d651d38e015f06d99cec40f9884039330ccf5f50293d8bc2aed5081b53de1d4c"
    sha256 cellar: :any,                 x86_64_linux:      "362dd9dca2bc3b37069353b301354cf9b0bb6ea995d1c8f71555d6d22c46c972"
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