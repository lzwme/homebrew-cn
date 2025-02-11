class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https:nextdns.io"
  url "https:github.comnextdnsnextdnsarchiverefstagsv1.44.5.tar.gz"
  sha256 "b8cd06c0ca9dfc4b71af611ba15c58c9e8d0191d60e244f5989ccc73c5e15983"
  license "MIT"
  head "https:github.comnextdnsnextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a59590e7b6db5e1d57d1a081ee3a4256d3642311d79af6f3e384df55b0d2d7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "724b9d60b5ee01fe9974b96865ec8ab40a6893d18852f2c326713dff92544d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efe01366eb31bcd17100db85b7074ca3a72d2b59b5438adb9529ff817c293ab9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4becd19cca9b3165d34af8a10c4222517440ddf654db8aee36c67b50b217049"
    sha256 cellar: :any_skip_relocation, ventura:       "eb740b83b831627d147e0e5640755245f60628c7cd72ed17dcea13d2b0444cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6edacd60473810d34e2b493e7edb4160acdea11cd72bafe95d6c0ea61fb636e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin"nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output(bin"nextdns start 2>&1", 1)
  end
end