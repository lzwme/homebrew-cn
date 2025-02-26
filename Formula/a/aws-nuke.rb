class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.48.2.tar.gz"
  sha256 "bd9bc6731d84d08215d3972eb44fdfa9124a40d32fd2d8bb1b09ef23fa341ba3"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817bf7836cc3d1f9dcc83b63821d61e5c3c9373c3e2874fd15463cb369f4ee66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "817bf7836cc3d1f9dcc83b63821d61e5c3c9373c3e2874fd15463cb369f4ee66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "817bf7836cc3d1f9dcc83b63821d61e5c3c9373c3e2874fd15463cb369f4ee66"
    sha256 cellar: :any_skip_relocation, sonoma:        "57ab46b40f71c96a2fa31facc6cf2dd8281cd280ace3d4b6fae9651624edc6a6"
    sha256 cellar: :any_skip_relocation, ventura:       "57ab46b40f71c96a2fa31facc6cf2dd8281cd280ace3d4b6fae9651624edc6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e02308d4f9d0e126e06cfbba089996f1566f022f3a626e7cce072dfdd3496d0b"
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