class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https:github.comjoshmedeskisesh"
  url "https:github.comjoshmedeskisesharchiverefstagsv2.9.0.tar.gz"
  sha256 "f3c880d73f1557aab765d4e0744d5cca572979f8639e7d90461ad4466bf32085"
  license "MIT"
  head "https:github.comjoshmedeskisesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9cbcf3cdeb6e5b9f5b924f6cb27de42eb166fabc4c575ca5961f96f91dbff8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9cbcf3cdeb6e5b9f5b924f6cb27de42eb166fabc4c575ca5961f96f91dbff8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9cbcf3cdeb6e5b9f5b924f6cb27de42eb166fabc4c575ca5961f96f91dbff8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a1574a9dafe5bc03e3ef18dc89c00545440b323f2dffc270b4d78634db7a497"
    sha256 cellar: :any_skip_relocation, ventura:       "1a1574a9dafe5bc03e3ef18dc89c00545440b323f2dffc270b4d78634db7a497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e13b872b2c54936b426f1769685129ef90629e39c85ce668086986b230f374b8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}sesh --version")
  end
end