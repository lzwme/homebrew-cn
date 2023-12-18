class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https:github.comgopasspwgopass"
  url "https:github.comgopasspwgopassreleasesdownloadv1.15.11gopass-1.15.11.tar.gz"
  sha256 "08cee0b4f9224d34364d212e3773d7a03250db410de5bedb2800b40977e0ce75"
  license "MIT"
  head "https:github.comgopasspwgopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b01ac6a4fa07e2ce1842b3fefad85f7474dcdaa9150ec00d914f5fb0e2ad4242"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70f242e3b7fd142b245839a4ea3bed5783b03ef78f1ca612a5cbf32fd4bb7d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44a4ddc667bbc2b56b47f4e046080404d25c00063ad61235a7a59bd040c8d73a"
    sha256 cellar: :any_skip_relocation, ventura:        "b62b112601a6d4b06be4590df32dcca3c61df3604786326bb2bad60e5aa1df0d"
    sha256 cellar: :any_skip_relocation, monterey:       "4554256f2a9882362cdbec36a4ac3ed18afb1f74f2c13465a562c90d1fde144a"
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