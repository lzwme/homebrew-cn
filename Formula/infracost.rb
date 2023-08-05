class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://ghproxy.com/https://github.com/infracost/infracost/archive/v0.10.27.tar.gz"
  sha256 "9ae1950592a32243be5ef7f270ad633e78f022813be6b4cf77f58fb9bc85a868"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de62bdcffc8ac0d641293e87b4d45faeacdfc732d8c73fb59f0aded994b1007f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de62bdcffc8ac0d641293e87b4d45faeacdfc732d8c73fb59f0aded994b1007f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de62bdcffc8ac0d641293e87b4d45faeacdfc732d8c73fb59f0aded994b1007f"
    sha256 cellar: :any_skip_relocation, ventura:        "8fb2422e7f7492f7c68705b0b1c24aff924df3d39965794e59646eea99f83fbe"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb2422e7f7492f7c68705b0b1c24aff924df3d39965794e59646eea99f83fbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fb2422e7f7492f7c68705b0b1c24aff924df3d39965794e59646eea99f83fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12fedf700d631e8beb6f6d6d81beef4ad05ef44b2d3ac5ee8eb44f5fb80df1e4"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

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