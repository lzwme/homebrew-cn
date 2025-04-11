class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https:github.commag37dockcheck"
  url "https:github.commag37dockcheckarchiverefstagsv0.6.2.tar.gz"
  sha256 "5a02109493ec2271253edf3850f550742e7a3032476e60e1da034866cbabdbf4"
  license "GPL-3.0-only"
  head "https:github.commag37dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb5df79311d3389a50244a71d35607ffb90a2139981496f9b4492e05b98b0a84"
  end

  depends_on "jq"
  depends_on "regclient"

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dockcheck -v")

    output = shell_output("#{bin}dockcheck 2>&1", 1)
    assert_match "No docker binaries available", output
  end
end