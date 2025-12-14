class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.62.1.tar.gz"
  sha256 "e12e30a0558a2a1c5f861a65fba24cb26bea71f38999897dbc27867a72437171"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7ef94afffdd426ffd16a2209bdf0edfb7818367b4c3ae88a1b2bb5a6387e1ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7ef94afffdd426ffd16a2209bdf0edfb7818367b4c3ae88a1b2bb5a6387e1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ef94afffdd426ffd16a2209bdf0edfb7818367b4c3ae88a1b2bb5a6387e1ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "e41211899d83c414df584bfbbf23ff37c288f11551e6983326574b104d22d966"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46d138014e2365e1e844bff6a99a96129ee1da06e3dae05d9db23b5bc50dcaf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd6c6dda8f6ebf9c9c3fe1d72144476a806bd7a18bff8f7868eb9fb44b8b8a44"
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

    generate_completions_from_executable(bin/"aws-nuke", "completion")
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