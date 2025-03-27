class Ratchet < Formula
  desc "Tool for securing CICD workflows with version pinning"
  homepage "https:github.comsethvargoratchet"
  url "https:github.comsethvargoratchetarchiverefstagsv0.11.0.tar.gz"
  sha256 "4913dd26c03bedd67beb232ae17a348c34df204fe9a3f57325a089c4c92b12ef"
  license "Apache-2.0"
  head "https:github.comsethvargoratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edcf5ec75e624b9c1bec9d18c8b0053d3091d9d2c40939abbd9b60cfdeae48b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edcf5ec75e624b9c1bec9d18c8b0053d3091d9d2c40939abbd9b60cfdeae48b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edcf5ec75e624b9c1bec9d18c8b0053d3091d9d2c40939abbd9b60cfdeae48b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "26cc8b980e8b1a5128528deafa59de21522885ff913b85545d11538c6df9f694"
    sha256 cellar: :any_skip_relocation, ventura:       "26cc8b980e8b1a5128528deafa59de21522885ff913b85545d11538c6df9f694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e39bbdd264c9fbed80d2b057b53efbd4a5a850bb9875744fa3424955fb6165e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.comsethvargoratchetinternalversion.version=#{version}
      -X=github.comsethvargoratchetinternalversion.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "testdata"
  end

  test do
    cp_r pkgshare"testdata", testpath
    output = shell_output(bin"ratchet check testdatagithub.yml 2>&1", 1)
    assert_match "found 5 unpinned refs", output

    output = shell_output(bin"ratchet -v 2>&1")
    assert_match "ratchet #{version}", output
  end
end