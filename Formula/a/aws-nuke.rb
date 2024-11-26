class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.32.0.tar.gz"
  sha256 "2a78f2cf6210f926c8db48c03b320aa5d587face9e67e47f54dacacb2c08fbe8"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "358b0064246435d6039e72fe61e8204e1770f41057dd305c0271bea5c1fe1e41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "358b0064246435d6039e72fe61e8204e1770f41057dd305c0271bea5c1fe1e41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "358b0064246435d6039e72fe61e8204e1770f41057dd305c0271bea5c1fe1e41"
    sha256 cellar: :any_skip_relocation, sonoma:        "331ec158ff4032830547a7056c9ae8e15e96a7aa7b27dce24d0fd088aaf049ce"
    sha256 cellar: :any_skip_relocation, ventura:       "331ec158ff4032830547a7056c9ae8e15e96a7aa7b27dce24d0fd088aaf049ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44367fb072b9a39edc68d7bc10674b5c6c0f0b94244a735a38c223abd4c93683"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comekristenaws-nukev#{version.major}pkgcommon.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkgconfig"

    generate_completions_from_executable(bin"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}aws-nuke run --config #{pkgshare}configtestdataexample.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}aws-nuke resource-types")
  end
end