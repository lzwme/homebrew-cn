class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nukearchiverefstagsv3.36.0.tar.gz"
  sha256 "014b0ac7ac8cc54fbc3d8cbc0c5cfac5620db7f6ad9ba73e50ec9010882b0ec6"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e75b14f4e38d9ad5fd35d34cf0973e11b6ab8d153c4f862278ae8dc318991e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e75b14f4e38d9ad5fd35d34cf0973e11b6ab8d153c4f862278ae8dc318991e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e75b14f4e38d9ad5fd35d34cf0973e11b6ab8d153c4f862278ae8dc318991e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "215af0d9d159c9542635daf2227e46a4cc0d7700df29fafd09ccdfaaa929b969"
    sha256 cellar: :any_skip_relocation, ventura:       "215af0d9d159c9542635daf2227e46a4cc0d7700df29fafd09ccdfaaa929b969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "860a73b4d8da7b171459d5f4440c21ee1d8a5f893a62a193b9167f9643783284"
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