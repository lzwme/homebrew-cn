class Himalaya < Formula
  desc "CLI email client written in Rust"
  homepage "https:github.compimalayahimalaya"
  url "https:github.compimalayahimalayaarchiverefstagsv1.0.0.tar.gz"
  sha256 "2f16737d4ff29b8495979045abb94723b684b200b98cab27ae45f8b270da5b9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e66116aba11287b4be107c4d469b2338bf77ed696cd2bfc1afa9ae79e9ebf2ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a975bfebc4e4c1bd7d3c265013b26b7001d0ef5642027670ecc5ab9511f68725"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e862a308f1bd66f94583c96c377c38a4711f12b7eeff917116611e9f29a3b86b"
    sha256 cellar: :any_skip_relocation, sonoma:        "90bb2235eede620bec1c0a372b4aa7ee01f294d262c1f02234f7e8ea83468516"
    sha256 cellar: :any_skip_relocation, ventura:       "296365ffa8b5da92cddad7153cc32526997d2df49dcc678ed3164466d2e090eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd3f80deef93d97135976a3bef2c7f40642b0637be71f7bf4c95e2861ccbde4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    system bin"himalaya", "man", buildpath
    man1.install Dir["*.1"]
    generate_completions_from_executable(bin"himalaya", "completion")
  end

  test do
    # See https:github.compimalayahimalaya#configuration
    (testpath".confighimalayaconfig.toml").write <<~TOML
      [accounts.gmail]
      default = true
      email = "example@gmail.com"

      folder.alias.inbox = "INBOX"
      folder.alias.sent = "[Gmail]Sent Mail"
      folder.alias.drafts = "[Gmail]Drafts"
      folder.alias.trash = "[Gmail]Trash"

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

    assert_match "cannot authenticate to IMAP server", shell_output(bin"himalaya 2>&1", 1)
  end
end