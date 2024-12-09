class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.35.0.tar.gz"
  sha256 "b23d5bfdf09a038421ec2057aecb4abdf820daceabecbddc8328f5ce51fb8fb0"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fadb233f1e37831822ceeb8db0d4ce91a9c32b4689d57c1ee7c1e933457e0bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fadb233f1e37831822ceeb8db0d4ce91a9c32b4689d57c1ee7c1e933457e0bfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fadb233f1e37831822ceeb8db0d4ce91a9c32b4689d57c1ee7c1e933457e0bfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "029ecbd41672aabedcadbd17f1087a3bda13c4600f68e1dd87b6534a68048163"
    sha256 cellar: :any_skip_relocation, ventura:       "029ecbd41672aabedcadbd17f1087a3bda13c4600f68e1dd87b6534a68048163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bdfb604434d3748c75ea666add345ad6dc5de7f9a8d4821510c2733a882e380"
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