class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https://pimalaya.org"
  url "https://ghfast.top/https://github.com/pimalaya/himalaya/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "0f58a5761490c2a96105073358487fa6032c79c0f07e962a65f6e8aeef782fd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16674e960b32ed7295279ce54484b5825af639d00c3099f0ba0d71266d5f044e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f171ebf557234779dd24e5489aa3e404990862db994a2333e5b7fd136ffa19b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "996494c7d83916dca29b1803eb7d0d4a5c357321821e90d10f639471fe3820fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5815b6cf30fa22c6856e425a5863eeb14cf704bb54ed47ba7d84340ab5636adc"
    sha256 cellar: :any,                 arm64_linux:   "9a86645a57a4f1d16c5d6f3893c944f9f846c6b8f3e3ff7cf460171236339c5e"
    sha256 cellar: :any,                 x86_64_linux:  "f5268464cc2ca301ea468398c54d4f65d7c4391b53c039725b534fe565fcd22b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
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