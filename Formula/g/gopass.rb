class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://ghfast.top/https://github.com/gopasspw/gopass/releases/download/v1.17.0/gopass-1.17.0.tar.gz"
  sha256 "fd8b390c551c4e86e38ee8a7ec6fff0686c4b44228ee9a6832da3ced01f73ad2"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4b67d6d9ac908f6f82299c9dc5d314937ba06ac2cb9bff2aa63b91e2b50fae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73788feec2c0b0e30f620f4d4751b48a4951bf728f0300a744b5a431534e42aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b8e82c20bb8101491009b457fce2e620cac39778c4a48358c249c1fdb07fbc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddff93392dc3b4e6a893e691e1e568f1b2fc04daeb7e8a88ff240194df44a5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d88155bfe5067aa189463c0822a3f5941957100f6d8b1ef06ae985a488219f"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    args = ["PREFIX=#{prefix}/"]
    # Build without -buildmode=pie to avoid patchelf.rb corrupting binary
    args << "BUILDFLAGS=$(BUILDFLAGS_NOPIE)" if OS.linux?

    system "make", "install", *args

    bash_completion.install "bash.completion" => "gopass"
    fish_completion.install "fish.completion" => "gopass.fish"
    zsh_completion.install "zsh.completion" => "_gopass"
    man1.install "gopass.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")

    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG
    begin
      system formula_opt_bin("gnupg")/"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_path_exists testpath/"Email/other@foo.bar.gpg"
    ensure
      system formula_opt_bin("gnupg")/"gpgconf", "--kill", "gpg-agent"
      system formula_opt_bin("gnupg")/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end