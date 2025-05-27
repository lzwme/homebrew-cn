class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https:github.commag37dockcheck"
  url "https:github.commag37dockcheckarchiverefstagsv0.6.5.tar.gz"
  sha256 "1bba0dbbb02942a5b9d357add210b4d862f0e2188cd20876bdb59be06c407dbb"
  license "GPL-3.0-only"
  head "https:github.commag37dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a26c1b3b807e2aefa1555369cb3417b80188a3364fa4e5d15fc8047e9e005d2b"
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