class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.54.1.tar.gz"
  sha256 "1c3c3f79fc064a7a91c9a8872d03609c92dca94908bd21a0bd12b82481bab18e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5242b5093efe4c92a32ce3b0418b9619bdb24a3ec0a205ad33c4cd66067c601"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dddd9ce1395c9205f6cb8c662e91d88ff84a2071c199e5e9173d947f1562553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83cf8d3eadb58e10777234def1263ce9caa09f485c018e56478e0b32b2073cdf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee08da59dcddd4ceb696e48d75c0c4aaec3f52653f9bd92394bb5937f7b4e9ac"
    sha256 cellar: :any_skip_relocation, ventura:        "51f72609995bcacf7f1c4b9f42a6a42a2ae9ef824f9906ed715c0e77933f41f9"
    sha256 cellar: :any_skip_relocation, monterey:       "8e62aee57ef02da9dd914d0c16cc54402f3b8c28976bbb952b7ca0c39d3a8d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa539e93c44ce2f9846e014daf43b033fca993bbbc985c378d6772f2139df67a"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end