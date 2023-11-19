class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://ghproxy.com/https://github.com/gopasspw/gopass/releases/download/v1.15.9/gopass-1.15.9.tar.gz"
  sha256 "1643f6d0c8f96fe758497a1efa18ca9210045e9f103c551f9ac1ce621b114fc0"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d4d6af6a263b443e7916e03a71695561683862ad1efed4fd7ca1e7f59bc7d37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f25ff73a24319a11d2a397219bf2f3d7069a2276ac1ccdcdeaf2f44b93915079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3030325a91da3ff01b8cdd57058c9ddb18f06d9580abcc809bd12c93a8a760f"
    sha256 cellar: :any_skip_relocation, ventura:        "0bece4525cda872374976e8498fedf0d66e7f2969681a4eb2d46c4531f1e0066"
    sha256 cellar: :any_skip_relocation, monterey:       "a54b154f5f1ce387ae76e3ed52828ec4d56378219f995dfa4aff81a449d99b6e"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    bash_completion.install "bash.completion" => "gopass.bash"
    fish_completion.install "fish.completion" => "gopass.fish"
    zsh_completion.install "zsh.completion" => "_gopass"
    man1.install "gopass.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")

    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_predicate testpath/"Email/other@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end