class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://ghproxy.com/https://github.com/risor-io/risor/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9ae044bbb63a7a4d51fc561d946f6622505d43c219118ecaf3e275d97fb8ab97"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ef24220de32ae85dd8b734c8be8472b69a507f779f678fd1236b96fe97fec7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "364d52610a16140c677b09707f3638f1599ff1dbc3392dba24a2a86f15dc45f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8012e13fc06ccbe5b39f40d57ccd8592d5d8ff866c36efa06ec122d92cd490d"
    sha256 cellar: :any_skip_relocation, ventura:        "93d86b09a8bf85f6dacf80803d6e1e4fc1f65a029ddc32ce0c6caea510cc1213"
    sha256 cellar: :any_skip_relocation, monterey:       "5b422a8474de71c7aa1bc686017d6c865ed4d056683b21863cbbf4ff214bd646"
    sha256 cellar: :any_skip_relocation, big_sur:        "9533d75f459da96e35370ca4cab5129b6401f1802de6aff41cc7a921fea95fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e02937b99396f5f028304f62e71980e8f304c23c094f847ae72eeefbb67a1e5a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-tags", "aws", *std_go_args(ldflags: ldflags), "./cmd/risor"

    generate_completions_from_executable(bin/"risor", "completion")
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)

    assert_match version.to_s, shell_output("#{bin}/risor version")
  end
end