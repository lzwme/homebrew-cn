class S3scanner < Formula
  desc "Scan for misconfigured S3 buckets across S3-compatible APIs!"
  homepage "https:github.comsa7monS3Scanner"
  url "https:github.comsa7monS3Scannerarchiverefstagsv3.1.0.tar.gz"
  sha256 "4b9b4dd0eeb663a88a1e9acf4e689098e635d29a13849f3a425d3b3c12df438d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5397b8ae24c6aefd933b2387b6920e76f5df7c245a3846561bb55f1c83d282f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5397b8ae24c6aefd933b2387b6920e76f5df7c245a3846561bb55f1c83d282f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5397b8ae24c6aefd933b2387b6920e76f5df7c245a3846561bb55f1c83d282f"
    sha256 cellar: :any_skip_relocation, sonoma:         "90b6569cf6e2932fc44cf84a4033d1da62690ce3d274a2bfeefd6877f947542b"
    sha256 cellar: :any_skip_relocation, ventura:        "90b6569cf6e2932fc44cf84a4033d1da62690ce3d274a2bfeefd6877f947542b"
    sha256 cellar: :any_skip_relocation, monterey:       "90b6569cf6e2932fc44cf84a4033d1da62690ce3d274a2bfeefd6877f947542b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea302cfba61c2f9da764780d80789832082d14f8356f20e803994b6604e87777"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    version_output = shell_output("#{bin}s3scanner --version")
    assert_match version.to_s, version_output

    # test that scanning our private bucket returns:
    #  - bucket exists
    #  - bucket does not allow anonymous user access
    private_output = shell_output("#{bin}s3scanner -bucket s3scanner-private")
    assert_includes private_output, "exists"
    assert_includes private_output, "AuthUsers: [] | AllUsers: []"
  end
end