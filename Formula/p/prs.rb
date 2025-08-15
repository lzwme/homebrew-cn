class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://ghfast.top/https://github.com/timvisee/prs/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "17ae3b528dd604976f7bd17918628a3c9aee4990c0b012e8f2caf69f6db45015"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b48e225f14e9e784741ef813bb3a97880550567669928ace7415aec15113b477"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e23cb6eea4dfe13e346bb4101136a25137992f3f43d8e634011bc64f2dc18695"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ba94e3daf380dc18ea2f0545462455e9b560dc92c0c7ab600db30ab26f48b53"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8c980b33c6b8eb983400ea39a13530d50aa4a60ca5c38103afcd2eb4498124c"
    sha256 cellar: :any_skip_relocation, ventura:       "e4c8240162779c624311a3279ff7d86e26fe6dd828e10ee74c1f15a908198488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86b757c282b1e90d7cc4b472292a3a5a86cc95161dcfbe57fca7ed0a4d728d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2755e0748612c12fd2b95a4af69a2959ccf4e46d0dac23b2b8c083f12d1020f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"prs", "internal", "completions")
  end

  test do
    ENV["PASSWORD_STORE_DIR"] = testpath/".store"
    expected = <<~EOS
      Now generate and add a new recipient key for yourself:
          prs recipients generate

    EOS

    assert_equal expected, shell_output("#{bin}/prs init --no-interactive 2>&1")
    assert_equal "prs #{version}\n", shell_output("#{bin}/prs --version")
    assert_empty shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end