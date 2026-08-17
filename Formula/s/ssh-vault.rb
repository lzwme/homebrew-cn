class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghfast.top/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.3.tar.gz"
  sha256 "7bc6513ed11dcaaa6c76302f1216d1b06f131527563156a7f7f3482967e90d6a"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76709fea85eb0022e4962f26b59f32c6307ecece777f7b01b7bcaf1995c2054c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8547d4d905dac538b0383b568d4d9c8f30575dc3fa5f122256493118bdd8f4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afe047b92a0a2a7db478dded32e9b0a87272933e7f85cbf5e9ce2288c1fdcc10"
    sha256 cellar: :any_skip_relocation, sonoma:        "765c5a91d33c801dbe877e1eb0858e2933ae6bb92a24e87b5d4d01cfbb99410f"
    sha256 cellar: :any,                 arm64_linux:   "50ce69024b8e5dad2b800a7b8a01c5603997461094cf9aa7d467533810a5d2fa"
    sha256 cellar: :any,                 x86_64_linux:  "cc3d12f77b6f739bf4bd92bd4b5c1db54ac68eb729167154702eda55d20a9683"
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