class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "dce5f0fe15a6de590f44b6c2d09e282300e30cb52eaff3e44c6643c960203cee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c7f34d3243aa23a756901cf3f4ffc831d586e19f30e1f43908c6a3d1e591907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ff4cff6554dc662703b3d395c6dd78332c7d34f3d4901628490f40c615a5e87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caee8a7bbf5cdcb36749337259190709ccafe0617d824f94082426ee1d4fbefa"
    sha256 cellar: :any_skip_relocation, sonoma:        "31051b50229f4a47c603f5dd29a9fe43b389ab93df3a0a7cb0d7b5fbb9ddc206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96449d0c78d48ff58e5749643ddc933be3bfba70ae21e583b44c0a54747c368d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc65750ef8b21a137a65c098cf33fa15a8c5290829d78a711accdb38636ce68c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end