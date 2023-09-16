class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "c23b47fd9721c9eae193941e6698bcb89461b35f4e416c15c5f40621baf473b1"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a61be04a55d0793f83f1bd72917f5d6c080967abe833c07d513614307d07fc47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce7276354d240ae4787f1f897728a5003e658338df5b9f2ca721e194d72c0674"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a17c3b69e22003230ef57ddce0ebe5049992cdb412f66df12d79a4ff724d860"
    sha256 cellar: :any_skip_relocation, ventura:        "5d84a2a01c689065585ee25ca6a0ac7f35e168fdae9eedaf2e8a9f4776328e36"
    sha256 cellar: :any_skip_relocation, monterey:       "76d093e39eb79efa016ee1eca31376c33bc4c178af5792541cfee1cbaa6e59d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "705136dced9b6e733ef13455a20bb50d1878b4234f44ff967d5e89f972049184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb791bc9a5d0f7fa7e046e6984bee2f02e3bbe2fc0dbfd9829cdabc6e9699cfe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end