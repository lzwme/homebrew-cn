class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghproxy.com/https://github.com/livekit/livekit-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c0278c92e58556709ce0da3d3adbbdda69898816584cdf64c66e6c77aa4fc3fb"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1e75b441aab01da40819bc0a439fd09ae64444b58b25b6043237703e22a281d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2398def9d0410bd664078cc0652672ff39856195f9f8bf29011efe14733ea031"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4adb88aa1cd41a91e3be896fa19fefcda6227c434ab8f35695474f51141d7ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "41048d94fec54772a82f5db911c8bcd6f1bc4d0815abb241bfa0daf11bb132a6"
    sha256 cellar: :any_skip_relocation, ventura:        "9fb2d84f298a1b5b021bef6abd5cbba526ec59ba3a17f3ae2a753dba8b6cfec6"
    sha256 cellar: :any_skip_relocation, monterey:       "85ce680ece6b14620b05ec1a03690f23f28cf31fb9707cf9fdd9433ef3bf4d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f76031aa4b2282836b166144535ec5b935ad6450b9e662ac38d9bdbe25dd837"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end