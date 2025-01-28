class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.45.0.tar.gz"
  sha256 "e625d3eb3a38509b047485c26f59d1d2abcf35bfb1a05c9a5270b35e6601438d"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a38b9c05a19c22eb64d06742794d99a8aaabb50637b5f8858fd5688cce437196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a38b9c05a19c22eb64d06742794d99a8aaabb50637b5f8858fd5688cce437196"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a38b9c05a19c22eb64d06742794d99a8aaabb50637b5f8858fd5688cce437196"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3dcab3ecabd7c47b6734aab44b5baa1790f49a1c4a842a1897eceba12736c6d"
    sha256 cellar: :any_skip_relocation, ventura:       "a3dcab3ecabd7c47b6734aab44b5baa1790f49a1c4a842a1897eceba12736c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e747bec2426bdf8f254f159c6bf1400346ed50de7b8859cf556c6982e8002d06"
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