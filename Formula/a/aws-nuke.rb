class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.63.3.tar.gz"
  sha256 "be7af50f73ac93436171e4b051793e00e926f9ee0711e7bc18d405f7ae2805e9"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "520a4f595424dde32bf186579be0089ec2e3691a1d5f985058cd3d6975693029"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "520a4f595424dde32bf186579be0089ec2e3691a1d5f985058cd3d6975693029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "520a4f595424dde32bf186579be0089ec2e3691a1d5f985058cd3d6975693029"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30fe205c82098d6b10c5623e7c93a8238849622c921a44dfd3cf905fefa34c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa4ee7b503b7e4dff826fd4f27058390072fdfec02ee3210327cbbcdb362d8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9f00df30b4767b144c4bfb6cbb1cc25ba25a14b2f82a1bc050177f07c9d6144"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end