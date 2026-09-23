class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://ghfast.top/https://github.com/gopasspw/gopass/releases/download/v1.17.3/gopass-1.17.3.tar.gz"
  sha256 "25cdfa2da64b0c416d73c5b87c87a0708da046d6eaba7623c4dbd47e7fa3563c"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa8d3ac4ee14a2656827eede87a46e8b5e4c0c30498ef3c7dd4fb77cb2afab77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a815f29491de007923e83d29b83f1275f85013492f8e1dbfa1f679f1ff859852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a021e11ad7c6409695268fa14e52a5295055e5690d7fcecfd133bf4f569250c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ba7674bfafbe446a66dd41c719fd8932cb658aaf45f563bbf4edb87ffd79c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8c992c243e1af667e10ff2b86c8400549fe72978f289a8bbb42d3f0c456baff0"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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