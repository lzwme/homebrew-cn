class Getmail6 < Formula
  include Language::Python::Shebang

  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "https:getmail6.org"
  url "https:github.comgetmail6getmail6archiverefstagsv6.19.04.tar.gz"
  sha256 "992d838b114842fb5055a85d9b581152b1b11ff444f20402b8662d9dd07d51ab"
  license "GPL-2.0-only"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c3c54257bf96d211850e6955d7e6a71bb7027876a7dfc259a7094eac51a02b6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3c54257bf96d211850e6955d7e6a71bb7027876a7dfc259a7094eac51a02b6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3c54257bf96d211850e6955d7e6a71bb7027876a7dfc259a7094eac51a02b6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3c54257bf96d211850e6955d7e6a71bb7027876a7dfc259a7094eac51a02b6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d387a9a7fc7645e62b7d457f513dc2ca77851e85933760d70bb0795388cf43f"
    sha256 cellar: :any_skip_relocation, ventura:        "3d387a9a7fc7645e62b7d457f513dc2ca77851e85933760d70bb0795388cf43f"
    sha256 cellar: :any_skip_relocation, monterey:       "3d387a9a7fc7645e62b7d457f513dc2ca77851e85933760d70bb0795388cf43f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3c54257bf96d211850e6955d7e6a71bb7027876a7dfc259a7094eac51a02b6f"
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