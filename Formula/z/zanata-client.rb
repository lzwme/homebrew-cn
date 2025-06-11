class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http:zanata.org"
  url "https:search.maven.orgremotecontent?filepath=orgzanatazanata-cli4.6.2zanata-cli-4.6.2-dist.tar.gz"
  sha256 "6d4bac8c5b908abf734ff23e0aca9b05f4bc13e66588c526448f241d90473132"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=orgzanatazanata-cli"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4e9a444168ef8759f044a71501e69d0d5f5d8e22dd29038bc8f784751341aa8d"
  end

  depends_on "openjdk@8" # https:github.comHomebrewhomebrew-coreissues33480

  def install
    libexec.install Dir["*"]
    (bin"zanata-cli").write_env_script libexec"binzanata-cli", Language::Java.java_home_env("1.8")
    bash_completion.install libexec"binzanata-cli-completion"
  end

  test do
    output = shell_output("#{bin}zanata-cli --help")
    assert_match "Zanata Java command-line client", output
  end
end