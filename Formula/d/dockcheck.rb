class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https:github.commag37dockcheck"
  url "https:github.commag37dockcheckarchiverefstagsv0.6.4.tar.gz"
  sha256 "8c6ca93335e71f71da8fe80f048cef2b469b1a3e456f9d9940d97b76b66e8964"
  license "GPL-3.0-only"
  head "https:github.commag37dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1b08612b7202b0e1a825e4d1c90e125a4362b50c964156eb57a07573edecee3"
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