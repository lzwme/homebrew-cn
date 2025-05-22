class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.54.1.tar.gz"
  sha256 "dcfacc119e072ebf89056921c3855b65eafbe55083ebdff14fe641656fbf9180"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "811f11aa2543b6b6b9ac93fa63e61ba5c2c511bd35f5017466a1537efdc10194"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811f11aa2543b6b6b9ac93fa63e61ba5c2c511bd35f5017466a1537efdc10194"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "811f11aa2543b6b6b9ac93fa63e61ba5c2c511bd35f5017466a1537efdc10194"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9c67c1bf7dfaf0b067b38ca51596b2ef60c2bfa74a1b1713eec568cbf105d90"
    sha256 cellar: :any_skip_relocation, ventura:       "e9c67c1bf7dfaf0b067b38ca51596b2ef60c2bfa74a1b1713eec568cbf105d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd6dcdbb29591d2770c0ed5784c4ce3d7aa821ddf2d3c11d5d7481ccf7e22367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1f1fc817e324aa55aff5086cde82f9a6095003f0370af6cb8115d0d67ead38"
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