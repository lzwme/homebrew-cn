class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.18.0",
      revision: "76d401cd9fb256b6e05c2af9630749fefdbda2ca"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a95afd1c4ffffc21521561f0984555580dd711a4398c951a11db8b335a9237e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5f3536403345c85c2b370d4ac3a0c81dece225943081520a81838aee8cdaa3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55350a21d88b4c7ce587dc5851c0fa1c6cd64220555e2f81efd8b8ec3712157b"
    sha256 cellar: :any_skip_relocation, ventura:        "ce9ba7113773bcea2b063c0c198ee85595b91a708f16d064648dd6e717bed9bb"
    sha256 cellar: :any_skip_relocation, monterey:       "f52a38e9de6afe50ae61fe7bb019251cf4663bb14934860d3bcdfcdba840c1ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6efbe7f64f87faf7e1e9776f29fe2725d615a59fbede971e4249c9cf39df790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6204815896a30248785faa67e94f8c9508ad159bc4ca9e2e8895833165b6f718"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end