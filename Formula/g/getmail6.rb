class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https:getmail6.org"
  url "https:github.comgetmail6getmail6archiverefstagsv6.19.05.tar.gz"
  sha256 "1b8ae957682f446c4c7103c075605c33c7456a4809788d1b769bd469ee90d38b"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d0d3044ddc889dca094c9c74de6b9cebc1990c26ae1cf581472b5846e30e62d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d0d3044ddc889dca094c9c74de6b9cebc1990c26ae1cf581472b5846e30e62d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d0d3044ddc889dca094c9c74de6b9cebc1990c26ae1cf581472b5846e30e62d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ad9fc279bfb480b7f89fcd79da25efa69424986fee612443a57a0442670096d"
    sha256 cellar: :any_skip_relocation, ventura:       "1ad9fc279bfb480b7f89fcd79da25efa69424986fee612443a57a0442670096d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d0d3044ddc889dca094c9c74de6b9cebc1990c26ae1cf581472b5846e30e62d"
  end

  uses_from_macos "python", since: :catalina

  def install
    files = %w[getmail getmail_fetch getmail_maildir getmail_mbox]
    rewrite_shebang detected_python_shebang(use_python_from_path: true), *files
    libexec.install files
    bin.install_symlink libexec.children
    libexec.install "getmailcore"
    man1.install Pathname.glob("docs*.1")
  end

  test do
    %w[INBOXcur INBOXnew INBOXtmp].each { |f| (testpath"getmail#{f}").mkpath }
    (testpath"getmailgetmailrc").write <<~EOS
      [retriever]
      type = SimpleIMAPSSLRetriever
      server = imap.gmail.com
      port = 993
      username = test@brew.sh
      #password = ... or
      password_command = ("pass", "test@brew.sh")

      [destination]
      type = Maildir
      path = #{testpath}getmailINBOX

      [options]
      read_all = true
      delete = true
    EOS
    output = shell_output("#{bin}getmail --getmaildir #{testpath}getmail 2>&1", 2)
    assert_match "Program \"pass\" not found", output

    assert_match version.to_s, shell_output("#{bin}getmail --version")
  end
end