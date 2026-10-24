class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghfast.top/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.8.tar.gz"
  sha256 "6e2d2b7e223c828db015cdda15b0d28e662dd9c8a13825f7a959f3bbd47071d5"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7cf7959eb0cceb22fb7b6f8bca52345b9e81017195a623bf1efb8118265c0a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47361e7bfa9c8b40eb5994722b24a722168911d3720a15a7bed7ba6f2d104004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b75916fdd694e95a1c753b552d4a361b997b242a8d84152e7a456b3cbccca48c"
    sha256 cellar: :any,                 arm64_linux:       "55330efe73da2869766a71991295b7f7af7c3f0c875fb34b86dae981509a57fe"
    sha256 cellar: :any,                 x86_64_linux:      "c2993eeafbbec6d0d6bd655f379353e2fe65f00d6d8390dd79b6ea16840b75e1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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