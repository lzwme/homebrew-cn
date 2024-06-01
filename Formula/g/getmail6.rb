class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https:getmail6.org"
  url "https:github.comgetmail6getmail6archiverefstagsv6.19.00.tar.gz"
  sha256 "2fbcf112464c97882b1fc1600258d547e3b202861f688b2c171affad89b0cb2e"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a14fd91733d8b08a66f8cc8a678c2ab7047db4bc787c40b1deed6f2764358bf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a14fd91733d8b08a66f8cc8a678c2ab7047db4bc787c40b1deed6f2764358bf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a14fd91733d8b08a66f8cc8a678c2ab7047db4bc787c40b1deed6f2764358bf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7079d254179debd45d4a90297d8a940087e2014ded75d443fd8a25e87fea686"
    sha256 cellar: :any_skip_relocation, ventura:        "c7079d254179debd45d4a90297d8a940087e2014ded75d443fd8a25e87fea686"
    sha256 cellar: :any_skip_relocation, monterey:       "c7079d254179debd45d4a90297d8a940087e2014ded75d443fd8a25e87fea686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a319f274f44e267a7577a76ee6bc2c7b4d558e4b102e64492bdfc084f6a34f1"
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