class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://ghfast.top/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.11.tar.gz"
  sha256 "52598be342b7a1db9ab175ae26338996d6faf9532812b22194345cab336c6ed0"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2ff5beaaa7b780d57f24a1e68cb23b0b17c3e4267e600521c31a9bdf8ef772d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76e000d33591307780fe3b2bdfbc90ce08ca9377512115cb2fdcd9554485ab31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cff9e7d73a2bba5f057108cb953bc593bd22fd0fea2cff5793f129e78fec6aa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c8abc02b2d71c1c79a4e55ea8499228dbd038b7541827eed45ddc80e2766ae"
    sha256 cellar: :any,                 arm64_linux:   "00203f4c68ee83cae3a6aa417babe3cff298abef5113e13b4ceed97ac165e68f"
    sha256 cellar: :any,                 x86_64_linux:  "2e82e7c712a8ce1b714adffc05e5ad8c5dfd40bc40d1248cff35f9cf07965701"
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