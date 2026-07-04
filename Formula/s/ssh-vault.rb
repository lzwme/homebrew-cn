class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghfast.top/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.0.tar.gz"
  sha256 "c1b15c835746f748818a0f4559aed895f2c77ab447f8986c0d1c511323d57328"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07b1d729b28946f6b60fb57439e41718dbdf8fcde54dfdbc9ec35896daa1ecc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80e0496d2a95ca66a8bc787b746c099d318aef0a588d21bfce34aace4584f9f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c32fed3584907ca7afcd0536d4d4912665d7bfbf8f0adbd63d6d1af674b30ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab520f403cb5c5b85f791f9de157af131bce59823b6a7533856eb48d2bf3af32"
    sha256 cellar: :any,                 arm64_linux:   "b03a58c74493396c1986f7796176049947908a642fe61df53c2e5d6bca7c67a8"
    sha256 cellar: :any,                 x86_64_linux:  "1fe9c4af9062490d565063b0a61471dc5b8ec6aa0bc0a695ebc5b40574139a42"
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