class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://ghfast.top/https://github.com/fullstorydev/grpcui/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "7b7e7bbb8d4749fc911a866a915ae987e4a45e680afb88c4fade5932cfaac2d8"
  license "MIT"
  head "https://github.com/fullstorydev/grpcui.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f58a00411eebe7b939118dcf1995c4cdaf891cb695541caa1be98691d29135bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58a00411eebe7b939118dcf1995c4cdaf891cb695541caa1be98691d29135bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f58a00411eebe7b939118dcf1995c4cdaf891cb695541caa1be98691d29135bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf64817c79878b649d1bc72a7beb1b22cea1b3b3ce605822260643ecbb70daa"
    sha256 cellar: :any,                 x86_64_linux:  "bca9ff53d266867abc651d9037b1116959f04cbb6f2ee21ac3e7572071b8484c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end