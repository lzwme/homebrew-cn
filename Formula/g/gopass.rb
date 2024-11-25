class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https:github.comgopasspwgopass"
  url "https:github.comgopasspwgopassreleasesdownloadv1.15.15gopass-1.15.15.tar.gz"
  sha256 "f1b0cf88f37d9de7c858021d79512be084b527dd00f3d9d762d660a29ad843aa"
  license "MIT"
  head "https:github.comgopasspwgopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7feb865d14842412b2719237a87a9b60b6fabd882eaa0b7e6ab5e2d6530c5c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f09d1bdac982684ab177ecaae648b62813711afc16bd00c0bc76d4f9a701009"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d10c21d8bc604e7543e57779abbcaa5ee9c8bd8b81f4a7b98002572f81c544da"
    sha256 cellar: :any_skip_relocation, sonoma:        "93bc5361bf7357dfcba1afcfac068879963ea9af105b0417dd95ed14e9a4af0e"
    sha256 cellar: :any_skip_relocation, ventura:       "8536e8e775cd7d03daf0ea01327debb9602cb4b51ee1a3131b6c857f3e628e1b"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "bash.completion" => "gopass.bash"
    fish_completion.install "fish.completion" => "gopass.fish"
    zsh_completion.install "zsh.completion" => "_gopass"
    man1.install "gopass.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gopass version")

    (testpath"batch.gpg").write <<~EOS
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
      system Formula["gnupg"].opt_bin"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin"gopass", "generate", "Emailother@foo.bar", "15"
      assert_predicate testpath"Emailother@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin"gpgconf", "--homedir", "keyringslive",
                                                 "--kill", "gpg-agent"
    end
  end
end