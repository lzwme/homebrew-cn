class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https:github.comstacklokfrizbee"
  url "https:github.comstacklokfrizbeearchiverefstagsv0.1.1.tar.gz"
  sha256 "c199050c5105ff54e2807f7490d915fa7427b5de0aeba85f4fd73c869545d29b"
  license "Apache-2.0"
  head "https:github.comstacklokfrizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b0cabac5584c54df9c17f507530b3751227ff6097413ef8f3d262245885d9fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b0cabac5584c54df9c17f507530b3751227ff6097413ef8f3d262245885d9fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b0cabac5584c54df9c17f507530b3751227ff6097413ef8f3d262245885d9fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "858071e4912804ca0fb9d7859f8f3b5ffa8db650f887ab7418873630eb532ca1"
    sha256 cellar: :any_skip_relocation, ventura:        "858071e4912804ca0fb9d7859f8f3b5ffa8db650f887ab7418873630eb532ca1"
    sha256 cellar: :any_skip_relocation, monterey:       "858071e4912804ca0fb9d7859f8f3b5ffa8db650f887ab7418873630eb532ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0717ad17f4a14e955345d1c875e987f6c8cbca7b1b0c8963bfbf437cfa2c61d8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokfrizbeeinternalcli.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"frizbee version 2>&1")

    output = shell_output(bin"frizbee actions $(brew --repository).githubworkflowstests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end