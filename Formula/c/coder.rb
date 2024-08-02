class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.12.6.tar.gz"
  sha256 "e51d6d37776ff267aa131d7876b25341665c1be5ca487c0be3969159fb3b486e"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d0208d1004ae54cd82311a2505b38a495028ddb004acb53accdd3750250a8da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44a55d0e7f21344a3694f366252c68c530885cb7e63caf44242acfd95ecdf08b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3178308e36dada2a6ad7e11f0154998d4bf574d883148a247fe8f7f1f7b7bfa1"
    sha256 cellar: :any_skip_relocation, sonoma:         "89371f416bba11a0d21903d570783308e5ff89a12f55a19826c5849cbd6f9559"
    sha256 cellar: :any_skip_relocation, ventura:        "b027fad0cf46e9325657682278078e113158fcfd68694ce19b33bd3c150a7ce6"
    sha256 cellar: :any_skip_relocation, monterey:       "453afb7249260dd2cdd04239afccb0d935111ba6ab454889473735a4591f3ba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa797d5594e013c505dcdbecde22f34e9c6a8fe903bd4575ea3693ef23627ba7"
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