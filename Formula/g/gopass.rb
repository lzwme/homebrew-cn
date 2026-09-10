class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://ghfast.top/https://github.com/gopasspw/gopass/releases/download/v1.17.1/gopass-1.17.1.tar.gz"
  sha256 "7b88c56fb021007926a8872ab5a5a9ea7ddfb6d0926eddc022c5e6e410908f56"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba147cf272ec24f46ee3332abe162e58bb9675f0b4ea0036e347116279f47ace"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4cee4f7e5276a9c3bec82f8c283dcce13c9bb42c3eb1aaf110617fbab2e8408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c116ac10168a3dc38b28f9efac6c0b5cf1b2e9bc6d5f2ccc078814f326fcd663"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b203f1e9c1352a1a7e2573618c46a77af3cc19218f9c2e3cac813205c7b2d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e56193526b35089bf1dd756943e810436f41ec3a16b653d9f65f09c6d67f61c"
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