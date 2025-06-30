class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https:github.comthevxndish"
  url "https:github.comthevxndisharchiverefstagsv1.11.3.tar.gz"
  sha256 "555a0b673487e02c4f3344d355da3dbbbdb7d4d5293897a875c52c5af0224c45"
  license "MIT"
  head "https:github.comthevxndish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09ac922898e6c1e7486ae0b535cef2a15fed39747343bf87dd8caecdc250aa3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09ac922898e6c1e7486ae0b535cef2a15fed39747343bf87dd8caecdc250aa3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09ac922898e6c1e7486ae0b535cef2a15fed39747343bf87dd8caecdc250aa3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "18209d738c2ad51461738c42ddb9ef322e46beaaef8a74230fd4ac6c7142c7e6"
    sha256 cellar: :any_skip_relocation, ventura:       "18209d738c2ad51461738c42ddb9ef322e46beaaef8a74230fd4ac6c7142c7e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc50b47c81c397e16a26c1a260a9c290d99f57867a2915639e50fd56898f6eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddish"
  end

  test do
    ouput = shell_output("#{bin}dish https:example.com:instance 2>&1", 3)
    assert_match "error loading socket list: failed to fetch sockets from remote source", ouput
  end
end