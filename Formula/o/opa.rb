class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "f426516ee9e09b19d4135441753a44346664f5769ee8c83b52095b0cded54828"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "299de102e7a3a43d5c22840f80816c806cf00825dc10345e6eec9156ae65cc7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ab74d860f482d8f8e70a155e53c09cb648c2dcc7d98806e7c78efd26f59171d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "096a8d4199bfbfcc2353d2012b2af87c593194439244d61434230d54f79b9cd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "874d16c94ce31381c00b943e1196ac85b04b73622c29a6018fd58cc7e0d7d5de"
    sha256 cellar: :any_skip_relocation, ventura:       "57d36e71730bbc47a8f5105da9e843cbabdefb1c9f1988a913b2673bcb693367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269ea4932ec8e4f386471e6c1c3bf3a560c1919b4364798ce3f00a898fb7d298"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end