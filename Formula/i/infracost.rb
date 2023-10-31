class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://ghproxy.com/https://github.com/infracost/infracost/archive/refs/tags/v0.10.30.tar.gz"
  sha256 "fb08b9b7c81e3874efaf27eb9660545875f4aa75e8efb682205333a3929145c4"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d19b5eb85ac3836288f30849bb6b618f0a28fda6467a50ad677a7cec829375a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d19b5eb85ac3836288f30849bb6b618f0a28fda6467a50ad677a7cec829375a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d19b5eb85ac3836288f30849bb6b618f0a28fda6467a50ad677a7cec829375a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b01dbd4a64aac38287b73a2d26edfc71f8a0a6b21cfd28206944b17ac1e3209f"
    sha256 cellar: :any_skip_relocation, ventura:        "b01dbd4a64aac38287b73a2d26edfc71f8a0a6b21cfd28206944b17ac1e3209f"
    sha256 cellar: :any_skip_relocation, monterey:       "b01dbd4a64aac38287b73a2d26edfc71f8a0a6b21cfd28206944b17ac1e3209f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8320d11f7a85dc22787df6db45a60bce1e10cf465e6a278cb552a03e0a26933"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end