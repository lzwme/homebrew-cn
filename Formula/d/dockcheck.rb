class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://github.com/mag37/dockcheck"
  url "https://ghfast.top/https://github.com/mag37/dockcheck/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "fa0f570f8ab2f3282375af8686f4e1fb4ba4ae14ae1b2d71923f0138f63cbba5"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7cd404bff37a4f5b0580b910607081c90c485b43a8e9a733096002e29af3a297"
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