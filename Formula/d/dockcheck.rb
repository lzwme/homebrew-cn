class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://mag37.org"
  url "https://ghfast.top/https://github.com/mag37/dockcheck/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6d2cb1909bfc9063959d496b8e99ad79884188be15de5e37071fcc368b560396"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe9db55687f2f31fcc46da61dc06238cdd48fc93fda9c7e566bf758483e46344"
  end

  depends_on "regclient"

  uses_from_macos "jq", since: :sequoia

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockcheck -v")

    output = shell_output("#{bin}/dockcheck 2>&1", 1)
    assert_match "user does not have permissions to the docker socket", output
  end
end