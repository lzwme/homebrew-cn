class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https:github.comTecharoHQyeet"
  url "https:github.comTecharoHQyeetarchiverefstagsv0.3.0.tar.gz"
  sha256 "11352164ee78184b04372034ad94ba83f6a18ee6248377e4b45f2d36d408913a"
  license "MIT"
  head "https:github.comTecharoHQyeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bff957d4bdbdf2536c79c130db94cb06a6bba14767a3d1db009324001c86bfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bff957d4bdbdf2536c79c130db94cb06a6bba14767a3d1db009324001c86bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bff957d4bdbdf2536c79c130db94cb06a6bba14767a3d1db009324001c86bfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f595ad2f46ef59eae6262318ed0e9ea4bc2dac6177f207f778062142053662cb"
    sha256 cellar: :any_skip_relocation, ventura:       "f595ad2f46ef59eae6262318ed0e9ea4bc2dac6177f207f778062142053662cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03f6a10ea7f02baf9c1db412df94e2cd1f464fd740a59286afbdf36b5f67511d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comTecharoHQyeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdyeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}yeet 2>&1", 1)
  end
end