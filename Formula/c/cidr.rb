class Cidr < Formula
  desc "CLI to perform various actions on CIDR ranges"
  homepage "https://github.com/bschaatsbergen/cidr"
  url "https://ghproxy.com/https://github.com/bschaatsbergen/cidr/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "445d7197afdaf320c6c39032b85a274b2a31e0984af06ecefa835e5cb2d7a259"
  license "MIT"
  head "https://github.com/bschaatsbergen/cidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bfa6df62cfe6a7ce62af52e36192ddd883f5ef6a4910b73f3742acb95fc2bf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0aff9070fcf6d95988a963072a9952728175bd385477ece56abebc056ff7d2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab11cdd73eae75caec5e3adc3547412328d64fc1c6e3fcb342e8b87e04bec937"
    sha256 cellar: :any_skip_relocation, sonoma:         "820fac35252f2688c026394ed1aca1ec9041f4ba44ffc931bfb7a0de3fc6697b"
    sha256 cellar: :any_skip_relocation, ventura:        "00511b1e77d9396a41a63a3a6e6acc97b5c8342a1aae526e7b81eb5ffec158df"
    sha256 cellar: :any_skip_relocation, monterey:       "1580181bdcdf0bac53e02bce3d379b8ff1c37f4a39ec3c2cc45112fabb9dbb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e4040bc81d843c2f2962c22b96120c15c57062a768f643e55134e37e197a042"
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