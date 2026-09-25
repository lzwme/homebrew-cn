class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org"
  url "https://ghfast.top/https://github.com/pimalaya/himalaya/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "491c7e51aa58874e2b70b4a0377e1770a1d3522392b9a9b867f965ac9d75aaa5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7018f91ada286aa08e60c22b8184276ed076126734849a370b059302c40d1b94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8046ca334ded160ac6ac7f9bf8656e25cc29589bc1b9b72f1ff34ae0fa79076f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf8045981d83b1e88532999614ac14a4fc5b77bb107de01d509dca32409095ee"
    sha256 cellar: :any,                 arm64_linux:       "c69ce7b5eba1afc71ff18e4b8157c187e1b8bfc2d1baaac2fa73882b4983e6c0"
    sha256 cellar: :any,                 x86_64_linux:      "87a8a1ba54db0772156360d3d9a6ca97683678e768257198b2c9eea33e813f6a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"himalaya", "man", buildpath
    man1.install Dir["*.1"]
    generate_completions_from_executable(bin/"himalaya", "completion")
  end

  test do
    # See https://github.com/pimalaya/himalaya#configuration
    (testpath/".config/himalaya/config.toml").write <<~TOML
      [accounts.gmail]
      default = true
      email = "example@gmail.com"

      folder.alias.inbox = "INBOX"
      folder.alias.sent = "[Gmail]/Sent Mail"
      folder.alias.drafts = "[Gmail]/Drafts"
      folder.alias.trash = "[Gmail]/Trash"

      backend.type = "imap"
      backend.host = "imap.gmail.com"
      backend.port = 993
      backend.login = "example@gmail.com"
      backend.auth.type = "password"
      backend.auth.raw = "*****"

      message.send.backend.type = "smtp"
      message.send.backend.host = "smtp.gmail.com"
      message.send.backend.port = 465
      message.send.backend.login = "example@gmail.com"
      message.send.backend.auth.type = "password"
      message.send.backend.auth.cmd = "*****"
    TOML

    assert_match "gmail", shell_output("#{bin}/himalaya account list")
  end
end