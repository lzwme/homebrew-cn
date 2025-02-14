class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https:nextdns.io"
  url "https:github.comnextdnsnextdnsarchiverefstagsv1.44.6.tar.gz"
  sha256 "81f697646a8d363293ab18c3bf45e80f405c284547794da37565bbf43d3023ab"
  license "MIT"
  head "https:github.comnextdnsnextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12c9e9a5456452f673919b66d6af187af345fe3e732e808dbe90cfb23e338660"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bf866c3b162efb5dafdd123396da2c98bd4e11b800ec78a67af46765e1dfb02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "723e151d10bad60c7eb5b0121cefd7fc8ab7d9b429cbe58ac015654a6b1ca958"
    sha256 cellar: :any_skip_relocation, sonoma:        "e56f0c75689b84b6deb79c210779ec544faf9476ccb20220baa29865adb5616d"
    sha256 cellar: :any_skip_relocation, ventura:       "37f04be89c69bc3acc359b2353a2b4f2f0a5d07a4fdf39782bbb6a3b8381a5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5bff941057570f209d9f3ffff8aa44f777d4d0c6c0e86ba774a11b55f07bb80"
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