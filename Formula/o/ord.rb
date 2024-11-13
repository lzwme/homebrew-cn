class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.21.3.tar.gz"
  sha256 "c0411d106057d622f6a7cc9cc6fc7bbfec82a081eb9bbd322f99074ff4859cf0"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e2e2e8ca60933cd4a7fc2fa71ea176a9c534260a4df68036c52c8eb9b40303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b4f1d0bbfe9fcd83a6f08f7e7936d1c5040f0469969cb719e60a628bfa4d6d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b86976ef160d88f05326457aa1d7b8a2ed38594bd6d86de57e2ac0e2975e671f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb7bb4b72a2d030b1f241913455521455b73e30767927640bf5eec6733bd6492"
    sha256 cellar: :any_skip_relocation, ventura:       "84f9bd47ed445490a813c7ff03befeec28cbe0a7cd099b25a8b236746009f322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c22dca94a37039b117b120688ec8976f9598d606678a513caf6d9b10bd189b0e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}ord --version")
  end
end