class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.87.tar.gz"
  sha256 "ac6b200e44d80d194dc7972959008e4c26a60447ed6c935d27330a331445eb55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6b5c2bbb76da98c45f469ca86e642f5476e7f645c502bdc615080537012d05e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6b5c2bbb76da98c45f469ca86e642f5476e7f645c502bdc615080537012d05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b5c2bbb76da98c45f469ca86e642f5476e7f645c502bdc615080537012d05e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ab4892adfe622dd2d71fc1a6ee1d0b0346b20caf66af19078db1aa4f12fbd12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f596fc947e9c7ac84ff10b5b4d71772b01b8871c039f9b240236f189feadd26"
    sha256 cellar: :any,                 x86_64_linux:  "0f1996ca1250aeca9f44d291bd01ce815657bee77931cd124987c68890fd87aa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end