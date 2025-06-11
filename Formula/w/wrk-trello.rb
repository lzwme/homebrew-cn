class WrkTrello < Formula
  desc "Command-line interface to Trello"
  homepage "https:github.comblangelwrk"
  url "https:github.s3.amazonaws.comdownloadsblangelwrkwrk-1.0.1.tar.gz"
  sha256 "85aea066c49fd52ad3e30f3399ba1a5e60ec18c10909c5061f68b09d80f5befe"

  livecheck do
    skip "Not actively developed or maintained"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "255e64f8c821c3e05bf04b13424ff23883aa00291b5f30da474584a7b609d3a6"
  end

  disable! date: "2024-08-10", because: :no_license

  conflicts_with "wrk", because: "both install `wrk` binaries"

  def script
    <<~EOS
      #!binsh
      export WRK_HOME="#{libexec}"
      exec "#{libexec}binwrk" "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin"wrk").write script
  end

  def caveats
    <<~EOS
      To get your token go here:
      https:trello.com1authorize?key=8d56bbd601877abfd13150a999a840d0&name=Wrk&expiration=never&response_type=token&scope=read,write
      and save it to ~.wrktoken
      Start `wrk` for more information.
    EOS
  end
end