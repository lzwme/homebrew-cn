class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.12.tar.gz"
  sha256 "009e40d4d7532e0e89c3dcd8ed561791c94592a497ada96f03556de5e9cefc6d"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c3d139bab014b8019520618f8bb7bcb8ab08f1d0413306bbdbc85f2371766d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c3d139bab014b8019520618f8bb7bcb8ab08f1d0413306bbdbc85f2371766d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c3d139bab014b8019520618f8bb7bcb8ab08f1d0413306bbdbc85f2371766d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "faf260894e36c30f91d5da257545ae8b1854df59631361e50e063c7234df4403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e9b1a6ec2052c6164feed44e405a621d6f4843842b92f65787d758fafe4d67c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c47b60b5854734b7b9afb0fc70dadbde15874aa6b00de319719b3d52ac96233"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end