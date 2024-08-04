class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https:jackrabbit.apache.orgfilevaultindex.html"
  url "https:search.maven.orgremotecontent?filepath=orgapachejackrabbitvaultvault-cli3.7.2vault-cli-3.7.2-bin.tar.gz"
  sha256 "3bc74bc82424aeaa4e1bd4d2cadab9d93c87bda5e67e09207140da5a4ba674b6"
  license "Apache-2.0"
  head "https:github.comapachejackrabbit-filevault.git", branch: "master"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=orgapachejackrabbitvaultvault-cli"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5ab48cb5bfcb928892edc54c09b0e401fdb3d69c2ad4a6db9df843867370e25e"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm(Dir["bin*.bat"])

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}bin*"]
    bin.env_script_all_files(libexec"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system bin"vlt", "--version"
  end
end