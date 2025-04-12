class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https:www.gopass.pw"
  url "https:github.comgopasspwgopassreleasesdownloadv1.15.15gopass-1.15.15.tar.gz"
  sha256 "f1b0cf88f37d9de7c858021d79512be084b527dd00f3d9d762d660a29ad843aa"
  license "MIT"
  head "https:github.comgopasspwgopass.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea1a999505bb9fc45de94d7c798a9d4a5085d467f3d5b01e6a267dbe72d616b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "538aefb269b6fff24e5f618f140787d032f146af739f01ac760e6824deee0a05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69dc4091d1142d25a59e44ab4614fa38cb5314d4bd80403f7de18e5ac5c3ccc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "af05bb99ecb7d158aa8883086304a995ad76d26593160b797e87167133b650b6"
    sha256 cellar: :any_skip_relocation, ventura:       "2bbbf7a40c463eb4ca6bef1a6c02a6998935fac8786461134fe56255e40e808f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48947aa1f84a98a70358a76dd3cdc882dab3a5ebd3ee228ad4e10313632d5c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9523381527deaef2fb45b7405872f973aac88c097d0a91563caf4f2b3248fde"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    # Build without -buildmode=pie to avoid patchelf.rb corrupting binary
    args << "BUILDFLAGS=$(BUILDFLAGS_NOPIE)" if OS.linux?

    system "make", "install", *args

    bash_completion.install "bash.completion" => "gopass"
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
      assert_path_exists testpath"Emailother@foo.bar.gpg"
    ensure
      system Formula["gnupg"].opt_bin"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin"gpgconf", "--homedir", "keyringslive",
                                                 "--kill", "gpg-agent"
    end
  end
end