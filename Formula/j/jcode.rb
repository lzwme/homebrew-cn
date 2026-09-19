class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.85.0.tar.gz"
  sha256 "b500c0e1caf27a21f25caf4a5da7d94fa3d01aacbf0a85208c7e3e47dbf342cd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d767baae02dec7b2afbc1bcee0b6bafce958f5298a2272755b7140d0a2f3d9c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8719a38cf1805ed883f7a5f38365661b5896cef1793675cf76182d2be42868d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55de79ed485c2d2c813f431d061c3918e7d29dae7b9fa0faa2b49d02c050166d"
    sha256 cellar: :any,                 arm64_linux:       "fa69fbf51e158899923436e5bd3d87ed22b1e0f840978ddb531b501f9ae1b8f6"
    sha256 cellar: :any,                 x86_64_linux:      "4e19767be351c7a0e4b493ad60c933c776c8495980d855e234369a3b2f90e6c2"
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