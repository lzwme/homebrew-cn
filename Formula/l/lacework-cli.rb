class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v1.44.1",
      revision: "a6de29c07e4a9cb92ae6a19014d499df30e88298"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88bc24a8417595cb6863c5925257700984e4940b13f017a8cdbfd990cf676979"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b62fa9b59a0e008bffc867da4f90c8fb3038e4312bc5a4cdda8737fc9afc5b91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea5fdf105f3293849c5ee6a86283f95d2eb4b29ca273b72f89bb50540b69c8ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e91a861954014487939c8e0152ceada55d0210458cb7ad2e28417fc4304e00a"
    sha256 cellar: :any_skip_relocation, ventura:        "7db7b3f279306c8bd95ae2091fd68094c6a363fefb840ac8d13edefad3dd210d"
    sha256 cellar: :any_skip_relocation, monterey:       "cbc86715d5f96aca8b7bdf5f03143fd3fc76f82bc0d518750a4016a5ddbe2822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369497f874f678d432c7fabdc189b3cd7bcdb831eb2c5684c24cedda8ce40446"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comlaceworkgo-sdkclicmd.Version=#{version}
      -X github.comlaceworkgo-sdkclicmd.GitSHA=#{Utils.git_head}
      -X github.comlaceworkgo-sdkclicmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin"lacework", ldflags: ldflags), ".cli"

    generate_completions_from_executable(bin"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}lacework version")

    output = shell_output("#{bin}lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end