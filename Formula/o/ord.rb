class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https:ordinals.com"
  url "https:github.comordinalsordarchiverefstags0.21.2.tar.gz"
  sha256 "5999cabaa2139d904cc4d22ec5a5c381f360d7c9d80e9c0e60b0fae44061741f"
  license "CC0-1.0"
  head "https:github.comordinalsord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55e9804761b588112abcfff210f097c6a420187acd7af46a5d6b39edb52455c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09677f9ffef0fb9d69b844e63a406f7aabfd779ddc50c26f2560c242e06de43a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b3ae56beb18f27d2a7515c22b9e491c657f0480baf3fe1d688171710361fa03"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0f980d5b42584b4dcaa204d026fd5817e8176331a04313d5284ac2674cc491e"
    sha256 cellar: :any_skip_relocation, ventura:       "c2c84d68ebc83d5c235d7d63372606665f27805e90dd52097a6bf67090bed353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fba7636f555de924f94e133875ea2f3ae60e02e23033a7a6ace73a0598703a6c"
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