class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghfast.top/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.13.tar.gz"
  sha256 "44bb9a8a5fff66b117814bc00267cbc229023b2d94c628dd68b21f2d7f1613a8"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c5524da8a4ea9db9f4d85773b1c6c36a2b5796bfa2abf64889ee84083214e63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220fb8884d53224adcd8e7606dd56968e13eaac9f083eb95e297113696373374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0246de18147a48949527a9d59aa2ec859517f6549626030337e7e9cba46a8c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3141b992bdad72b0fc0f150d0aff137f3c53f9c1451eb132a78fdcf554207ff1"
    sha256 cellar: :any,                 arm64_linux:   "e24a38f3a1c86bf74c40258d943cae40857d6745ee9c8213ad64f074b862b30d"
    sha256 cellar: :any,                 x86_64_linux:  "3cdcac0271f5b0de1244a07a88658d071858e1d5429b3fcabc7fb9d8406894c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)
  end
end