class Signmykey < Formula
  desc "Automated SSH Certificate Authority"
  homepage "https://signmykey.io"
  url "https://ghproxy.com/https://github.com/signmykeyio/signmykey/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "162176a7a32c0c2a47707680d45662a8b68e18488c6d6fa76a05d07933bef6e2"
  license "MIT"
  head "https://github.com/signmykeyio/signmykey.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36987608b9eb8d9deb295a4afee0b8fda2f2156a6ca68585f77f7813d31ea0d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f40780465a8da29ef9061e99af3f3ad5175629cf9430c83bfcca556035f173f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "336f18aa67791a7ddb28f94590cb5c7b3b65cf02ee3e535b69d01ec15d3ec300"
    sha256 cellar: :any_skip_relocation, sonoma:         "aacc9c9360d6b4afdc3cb6512c39484387c77a169b9ba9339df51a693561214c"
    sha256 cellar: :any_skip_relocation, ventura:        "7ba7f779e0c77bafc7d0e3b341a9da6c49fe01a6579513ce018bc826246e6940"
    sha256 cellar: :any_skip_relocation, monterey:       "1c5dd56b9180932570158a31917d69e9c58c77ba584264b35904ac7340cef322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "624db3ad576befe587328a3c71e8ce7ed29905aeae2051f4b53d2d09d042b155"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/signmykeyio/signmykey/cmd.versionString=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"signmykey", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/signmykey version")

    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/signmykey server dev -u myremoteuser")
    sleep 2
    assert_match "Starting signmykey server in DEV mode", stdout.readline
  end
end