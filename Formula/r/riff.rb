class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags2.30.1.tar.gz"
  sha256 "cee36ef37884765a58f8ec277c28eaed14474ac0c35e5f2136c670310989ee87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3df589d47f3b5e168b67a9b62177482857cb256b0ee245eeb3302aff2d2c0966"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acd14d88868dea1551f3207c0335d0183d5e9c32c49b98a724aa9122b6778413"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb51ec92072baa263ea920309ad12dca202ee64f0ea73430397b22b587e59eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "30e4bdd315c7c56a7acb36b1e1cf5115dd3ea19079fe0b15f43402b0f2cfd845"
    sha256 cellar: :any_skip_relocation, ventura:        "9667a5536f0a1ba980491a46e06cd6d44b280d03fd916f9db846e3d51a669622"
    sha256 cellar: :any_skip_relocation, monterey:       "4d144cf8ec11f79534d76d4a62bdacf0a872118f6eba9a74e1b11a0aa83043cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce335dd82e4fee1c38b35bbfdd0e987c7297d827e6531237f02915c67f60db4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end