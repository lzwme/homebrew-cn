class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.43.0.tar.gz"
  sha256 "52bce7eadf8c09db9de4b89fd7ad6f7092b356a1b84c57531ddaf83cf465e0e8"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a17e677cd62dc29103a1f7f86a3e939721d2f8658bf3e7241efe739f4df234b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a17e677cd62dc29103a1f7f86a3e939721d2f8658bf3e7241efe739f4df234b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a17e677cd62dc29103a1f7f86a3e939721d2f8658bf3e7241efe739f4df234b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1918e7877072fae6c8b592fc21fdaf182f8e10d2fb9f658d67857cc1c45755d2"
    sha256 cellar: :any_skip_relocation, ventura:       "1918e7877072fae6c8b592fc21fdaf182f8e10d2fb9f658d67857cc1c45755d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2aff6e06db9aa4c91f1ff5607154a2b775126228bf303539fb368e64b862da"
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