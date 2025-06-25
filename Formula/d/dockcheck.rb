class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https:github.commag37dockcheck"
  url "https:github.commag37dockcheckarchiverefstagsv0.6.7.tar.gz"
  sha256 "cead1f7ae95b2cafadb70638f41e9a17d24e70c79efe50b4aa4b557e7d67b28c"
  license "GPL-3.0-only"
  head "https:github.commag37dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e97e5124048c31afc7fda841805e2add4c0c2769b51e2b9c5534f2c6ea96206"
  end

  depends_on "jq"
  depends_on "regclient"

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dockcheck -v")

    output = shell_output("#{bin}dockcheck 2>&1", 1)
    assert_match "user does not have permissions to the docker socket", output
  end
end