class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://ghproxy.com/https://github.com/gopasspw/gopass/releases/download/v1.15.10/gopass-1.15.10.tar.gz"
  sha256 "f9828361c9ae975b483c144108b443d76fb13cc4c2909138dd13a9fb3fc98f11"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "066c7bb049774525f2ed07b2ad9feb99fceaeda012e44f70eac5f24ac87bb07f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba2b6068ccf44c7c106ea091d28d91d5ea0992d36729f972e9129db310a30bcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0f2ccfd230a31231a3832a6ccaef2cc6e6516df43936d569ac190db97e7c649"
    sha256 cellar: :any_skip_relocation, ventura:        "09f0d0796edd6dc54e0bb7cfb35f3802fc72d73727ae1145c701f7ae0a1fb1d4"
    sha256 cellar: :any_skip_relocation, monterey:       "44bff70f76d0502d336d4e4175b4b5068471ebaef1952348e37c4f8673e53456"
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