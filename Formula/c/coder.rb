class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.19.0.tar.gz"
  sha256 "8abb30ed3760421b9d8ee4fdee783fd80ef14ce46d7c933622f738ddeb0246cb"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39b2f79535b38b66901be04139f633686397b92b585d83683aeb9156ffa11492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fe22043860ef6ce1d345a90f3c6bd259e6fa3b4ec5360a7a8d0adff8dde7eae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff1eecd6599bd158700aa610d4b961d18322d1add83e7dc07fbcc0204105e2d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c75332a09df4f86854ea16e68e66a792e2c0a833f187c4c2e1fd784b91a3b17a"
    sha256 cellar: :any_skip_relocation, ventura:       "7bbd188bd28bbac4758e0a6f4f0571883da905f19e4e21dd1995699bc6fdb9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83848abeea808bd9bb490218d65fb85370c0e6c3ea61820cc81aa113ad134b5c"
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