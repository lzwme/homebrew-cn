class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https:github.comstacklokfrizbee"
  url "https:github.comstacklokfrizbeearchiverefstagsv0.1.2.tar.gz"
  sha256 "0061c090b59ee22599b76d46fcf4b79f0d2402987c8d720c6de03fba46d4c4b9"
  license "Apache-2.0"
  head "https:github.comstacklokfrizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6c3f639d48aa9f2aab1f6836b2da1f17d244b968720193a9a6358b1c27a876f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "138a05f755b59f97f49d46ea9bc304188d7f6dfb44303778ef2a0966819aa825"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "138a05f755b59f97f49d46ea9bc304188d7f6dfb44303778ef2a0966819aa825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "138a05f755b59f97f49d46ea9bc304188d7f6dfb44303778ef2a0966819aa825"
    sha256 cellar: :any_skip_relocation, sonoma:         "a58254f2fcafb7fd54818b9b0d4fc16605a3229b40475bc51cd1f708f334a2a8"
    sha256 cellar: :any_skip_relocation, ventura:        "a58254f2fcafb7fd54818b9b0d4fc16605a3229b40475bc51cd1f708f334a2a8"
    sha256 cellar: :any_skip_relocation, monterey:       "a58254f2fcafb7fd54818b9b0d4fc16605a3229b40475bc51cd1f708f334a2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c441ea87564702c9760362b3ec805a4fb47df361c45e93307ba40202eddaf43"
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