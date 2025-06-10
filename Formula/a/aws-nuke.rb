class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.56.1.tar.gz"
  sha256 "9efa902ba1ad227f79069ac2424b61db66607aa572cfc74730066b13f38a6250"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5709c1690352bf0bbdf8e162baefb09977fa7dcd5ff9979c18ff87e75c74ed18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5709c1690352bf0bbdf8e162baefb09977fa7dcd5ff9979c18ff87e75c74ed18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5709c1690352bf0bbdf8e162baefb09977fa7dcd5ff9979c18ff87e75c74ed18"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2808e80152ae150465e6293e7c6eb9323305a00dd953573070e0c68ef5b984b"
    sha256 cellar: :any_skip_relocation, ventura:       "d2808e80152ae150465e6293e7c6eb9323305a00dd953573070e0c68ef5b984b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4007dedb707c356564e31916c3718801c74c083fab0dbb9ae02cf8028be2870c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59ce6b058de98a34298d325c29808a9e77641a52ab13e92510900bf4a2d359bb"
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