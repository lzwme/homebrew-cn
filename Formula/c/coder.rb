class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.12.5.tar.gz"
  sha256 "cfeb650c18f52b6765349cf4bfbe15d470a69b8217da457d02419ec18b30bd01"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67ed0c8dd688168db576e788b83577458cf4649dfdfb223503c1715831b69066"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9a950930451d818cb612c82c630f07b2d65455f4fb0c586f3b8bac5e721c949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e13af25f482dfa285ebd47b433a4fe5ea3e508754f984f6f90c6fa074900a770"
    sha256 cellar: :any_skip_relocation, sonoma:         "7293dc7433422dcddd0bcb86c8170433aad717e8e4ea3b30e5492988164c2580"
    sha256 cellar: :any_skip_relocation, ventura:        "c4c9f4935febecc47e2131e643a6c017870ccd2fb75c814b44b54eb7659f04ba"
    sha256 cellar: :any_skip_relocation, monterey:       "c974b1d3999ab7904e6c245952aaeb8308e607e3eb4908603648d8ebe932d0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a020a3a176da506d57c514185d6f684b477052295c2fb9fc46bbbe206592680f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end