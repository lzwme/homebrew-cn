class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://github.com/mag37/dockcheck"
  url "https://ghfast.top/https://github.com/mag37/dockcheck/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "5c015b96c400b619daa918933d0805b1550bdfc3a111393cd6c939f3dd25e0ac"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d51deea0bd69c764aef3b3dab95af66bdd3097d51a228784852ba88998300bf1"
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