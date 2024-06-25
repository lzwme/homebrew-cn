class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.11.4.tar.gz"
  sha256 "f208257008dc8c9c3cc910d8ecd509bd15753ae4bd6716c9933a52e554ea0475"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d273a91fdcbf22957f1af31b461c26a3129bc5f81a65b76a4eff32c89729cb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed36b8844237d542440c9a0039bb59deead672dfea6c50cd024216e73d049c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "550162e4061e6bc464fad2e764ffdca9328128d8ae20396596c82cba749a7566"
    sha256 cellar: :any_skip_relocation, sonoma:         "34fbfa16379b4f257dd05a45edce68172976b3137dc7ac130307e17a51db5ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "048d08b3d835a2a91a12dc2ad7aa9c54c7051ac209b5038f5f261497897a5ad9"
    sha256 cellar: :any_skip_relocation, monterey:       "926aaff4f1de562329132c378e95b76693fc5543019d64e7bb5ebd5069b81594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eec7f67a0efc69234b910b7caf7f3d4db12427a5ddb432fad907a05f8146d05"
  end

  depends_on "go@1.21" => :build # see https:github.comcodercoderissues11342

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