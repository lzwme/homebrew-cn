class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://ghfast.top/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.58.0.tar.gz"
  sha256 "a961c926647fb336c70fb66c1b85ab8746a7e58cd6aa9c3ca60d987d342e6966"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23b627e3828f2cb832af89b87e700c52495c405af63b12e9597e6351da18a715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b627e3828f2cb832af89b87e700c52495c405af63b12e9597e6351da18a715"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23b627e3828f2cb832af89b87e700c52495c405af63b12e9597e6351da18a715"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f7dc67c38b79c00f4f7aabefacbcbe9b91502962ff1d5f0650e184fedee1a00"
    sha256 cellar: :any_skip_relocation, ventura:       "8f7dc67c38b79c00f4f7aabefacbcbe9b91502962ff1d5f0650e184fedee1a00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f5fcfa52ce2331e7dcb78d97ef47242b0c7399ea7512a4515a3b5bbe24c0ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "287304b2152e5312275c5c0f4cd4fac7640fabf03def4342f5164ee5faa08c0c"
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