class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://github.com/mag37/dockcheck"
  url "https://ghfast.top/https://github.com/mag37/dockcheck/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "fd650cdb1f134ddf7967e0f1d676d2552d6b4ebda790309fd5aed34cfc84b920"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e8e24c91b153f7fc8b42588472528977b6ea2f9ff9d3d0a1abba363929a2fbe"
  end

  depends_on "jq"
  depends_on "regclient"

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockcheck -v")

    output = shell_output("#{bin}/dockcheck 2>&1", 1)
    assert_match "user does not have permissions to the docker socket", output
  end
end