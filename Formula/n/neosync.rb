class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.31.tar.gz"
  sha256 "ae0a5fd8b3d414e8198ba92fbd3613d66976e96a57c766a8a65dbfc487ab310e"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c976b5430f15aa04b486bd79707f5bb2c25eda7e8ef4b0df76e8f51a81cf7667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c976b5430f15aa04b486bd79707f5bb2c25eda7e8ef4b0df76e8f51a81cf7667"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c976b5430f15aa04b486bd79707f5bb2c25eda7e8ef4b0df76e8f51a81cf7667"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e3ed1cd5b9ea64e56a5d7ad53ecd11a2378bafba9ee7e2895193a255733b317"
    sha256 cellar: :any_skip_relocation, ventura:       "2e3ed1cd5b9ea64e56a5d7ad53ecd11a2378bafba9ee7e2895193a255733b317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "473dfed9ba67ced5c7a534420faeb63609fac9440e7ae3e172cf5511a5ffd883"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end