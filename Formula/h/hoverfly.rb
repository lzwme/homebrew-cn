class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.3.tar.gz"
  sha256 "3a48e8f037000549bb90f0eada66cc7dfbf3b7a6301e703328969d58bcb8c3cf"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "045a34c4afbaf6213bd7d7f75afce685fa49c619cfc6460aab21c06da45f7850"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "045a34c4afbaf6213bd7d7f75afce685fa49c619cfc6460aab21c06da45f7850"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "045a34c4afbaf6213bd7d7f75afce685fa49c619cfc6460aab21c06da45f7850"
    sha256 cellar: :any_skip_relocation, sonoma:         "57fa115fdbd2764bc40a2157afee54bf477b18d0c498a2c1b1a0c4f1b0353282"
    sha256 cellar: :any_skip_relocation, ventura:        "57fa115fdbd2764bc40a2157afee54bf477b18d0c498a2c1b1a0c4f1b0353282"
    sha256 cellar: :any_skip_relocation, monterey:       "57fa115fdbd2764bc40a2157afee54bf477b18d0c498a2c1b1a0c4f1b0353282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b63eff2b484b0775c0acd14daa1e2f921e2917ffb15638e5c5bc86263c86ce56"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".corecmdhoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}hoverfly -version")
  end
end