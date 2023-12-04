class Cidr < Formula
  desc "CLI to perform various actions on CIDR ranges"
  homepage "https://github.com/bschaatsbergen/cidr"
  url "https://ghproxy.com/https://github.com/bschaatsbergen/cidr/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "9c634c248de5db69a91c950186ae9254150697eefdfcefd2ab5c9ba4e6e6c763"
  license "MIT"
  head "https://github.com/bschaatsbergen/cidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66f5d438e7f80d572ff586f5b5c187c96b65d25f41947e7d383a5083c902455d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "733e68cb1e2f1ab3efc80c66172d810b215e37196cda1c00486c8161532edddc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7062422aa83fc4c5227afeda0036c5dc1dc8607ce3425e17904d8c083abd4e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9370f82f2de34fcc7583b0beb4f209218ba79d7319531c2e228a7d9e95df393"
    sha256 cellar: :any_skip_relocation, ventura:        "e36a57669376e2c07d67cf9ffafa2453b3e41b1b91400796cc2d8bffc914c359"
    sha256 cellar: :any_skip_relocation, monterey:       "c9a6f853d7d3271bae062dbd15d85308cd0613da253dc0129d4ce986d543a75f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "456eb7a5975e867538aa3a80599fd461a3ee6de20b5f61593ae801f72f047704"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bschaatsbergen/cidr/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cidr --version")
    assert_equal "65534\n", shell_output("#{bin}/cidr count 10.0.0.0/16")
    assert_equal "1\n", shell_output("#{bin}/cidr count 10.0.0.0/32")
    assert_equal "false\n", shell_output("#{bin}/cidr overlaps 10.106.147.0/24 10.106.149.0/23")
  end
end