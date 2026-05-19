class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.64.3.tar.gz"
  sha256 "ff3804bbe5c712a8b11e7bad8fb06d10b07d75f7cf2be6850e98b1290b25512d"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abe0e0c3da0bd38c490051fcf920eb3b98cabe1a5237fa5ac4c4304311a64361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abe0e0c3da0bd38c490051fcf920eb3b98cabe1a5237fa5ac4c4304311a64361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abe0e0c3da0bd38c490051fcf920eb3b98cabe1a5237fa5ac4c4304311a64361"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad2a0d9b84fd9753329126aadf549a92db22f98b5735e487e27d83267e1a824"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92e80a3be961a108f3011315f95cdd2afe2cacc7a3487ea0185894dfb509b9c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cf3f3468709e0c32cdbbccd06784b9f4867c1d1364ee7bb7adfc7b4a6a83d9e"
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