class Cidr < Formula
  desc "CLI to perform various actions on CIDR ranges"
  homepage "https://github.com/bschaatsbergen/cidr"
  url "https://ghproxy.com/https://github.com/bschaatsbergen/cidr/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "91fe6434dfda9da6effbcc135fe22cff32c5ed5e2ff4be224421f042119e8ba7"
  license "MIT"
  head "https://github.com/bschaatsbergen/cidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdac11350770d6b888f261e400db4f3e257f8beced0e192e9a7e99758047a9a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e21274671b8f89183f747c712a78fcc81a406073b4b340724eb2bd9772b6a53d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61814380fc105534f2fe2a30bd082c8dbad04437e251709f570135fadddb9d06"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bb2fc339b91f85207ada16681e1871d661b9a9febe006085339d7377e93db0a"
    sha256 cellar: :any_skip_relocation, ventura:        "4353ff825b78a6369b527dc4eece8cb34694a0bf6013fccde844afef7495c7dc"
    sha256 cellar: :any_skip_relocation, monterey:       "e28029db77ea670a6bb8d3d6b0cc4e393837e8c531e687313ecc1b33d4952eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5137be02750001a727393147607efdf0767ed72394f75d75bda594567fd25462"
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