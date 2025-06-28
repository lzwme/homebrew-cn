class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v2.3.1",
      revision: "6374ec9e486707b85c290045e5733b6e0f9af828"
  license "Apache-2.0"
  head "https:github.comlaceworkgo-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0096565567de990a98de1e14fac89e3ffe4a821fcc0e69de087de571dc8d47a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0096565567de990a98de1e14fac89e3ffe4a821fcc0e69de087de571dc8d47a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0096565567de990a98de1e14fac89e3ffe4a821fcc0e69de087de571dc8d47a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7618c8c7ebe8aab2c16911081e22417fa0f8ad57b9a47cf9fdd261d12ee53966"
    sha256 cellar: :any_skip_relocation, ventura:       "7618c8c7ebe8aab2c16911081e22417fa0f8ad57b9a47cf9fdd261d12ee53966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e679811fafc2c0cdd5d876147b59c22a65c344abdb13d9a083cef6b05f473d0d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comlaceworkgo-sdkv2clicmd.Version=#{version}
      -X github.comlaceworkgo-sdkv2clicmd.GitSHA=#{Utils.git_head}
      -X github.comlaceworkgo-sdkv2clicmd.HoneyDataset=lacework-cli-prod
      -X github.comlaceworkgo-sdkv2clicmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin"lacework", ldflags:), ".cli"

    generate_completions_from_executable(bin"lacework", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}lacework version")

    output = shell_output("#{bin}lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end