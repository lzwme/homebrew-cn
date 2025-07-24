class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.13.0.tar.gz"
  sha256 "8b3851bac8ebac3c973c0f82fcaf1e4cc7a68d4effe3a4d727963b3824972909"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bf25c12f799ad426b68825743ca0cb24af3cd44c28e48751dfd4800c50b313f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7d368fbc5f4514d1439cd307122304e5112e31007813ae0f3ddc7041f79e6c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b664a9639a540391dda00f6784451d0ae6854545605751a37222e89a7cbb1993"
    sha256 cellar: :any_skip_relocation, sonoma:        "928c6a3f401396cac2fb1e0c2d6e52f81862de7d44a67e2d41470fa29dc504ef"
    sha256 cellar: :any_skip_relocation, ventura:       "0e8c94e2670a7cb88fb789b27de95b5a8d76d0490e3c913649777365348ea2b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "821913d9580a35ae7435802f835042dff444c7cf2a7124f9dd2b8cadc2649f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a000fae5c0651d38bcbd543107d63d5c9b424745933d9e1d53a88f4b1f56db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end