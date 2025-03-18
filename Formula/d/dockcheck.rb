class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https:github.commag37dockcheck"
  url "https:github.commag37dockcheckarchiverefstagsv0.5.8.0.tar.gz"
  sha256 "bb9c5b5868496188ba001c8a81acf34da1e774886571819ab636ef80afc6a56d"
  license "GPL-3.0-only"
  head "https:github.commag37dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e2bfd6f23a61930d729b915a2ff87721aa397b4793c0d7e1c6ccfba231bbaf5c"
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