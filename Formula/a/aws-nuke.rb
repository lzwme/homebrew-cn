class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.39.0.tar.gz"
  sha256 "cb4f09d4e319e511c9926bba47141271d5ce21c2f57d8776a253543020a2249e"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9655f9fe3f71cb485ed65dc1ab20d4ff352a956adf593a2f9ab20573f005240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9655f9fe3f71cb485ed65dc1ab20d4ff352a956adf593a2f9ab20573f005240"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9655f9fe3f71cb485ed65dc1ab20d4ff352a956adf593a2f9ab20573f005240"
    sha256 cellar: :any_skip_relocation, sonoma:        "955479f9acaabece7ffc92b932546db2dbdaee81ac6e751829d7258f8cafddb2"
    sha256 cellar: :any_skip_relocation, ventura:       "955479f9acaabece7ffc92b932546db2dbdaee81ac6e751829d7258f8cafddb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b14a796683057247fcf0c1376e7dea31c3d8e9d8d0f8fe695999a226ab95854"
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