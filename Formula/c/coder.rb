class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.23.2.tar.gz"
  sha256 "d9b46c54e06d493073f16676f66ee81ad1cc0fabf76f2752e57ae76d81fd470e"
  license "AGPL-3.0-only"
  head "https:github.comcodercoder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d4e11478fac0e49e2631a15108320ba418ffddcd71bf1e47dd97a111d0efdd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90b00562c61dee47ead165e4ecf2df56123c33e15478b22698063093abb8d345"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b82a9356e0ba330871d6f15f8105ea52864b1f28d5e2cedea543793c8ecaba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1e74a6d9f231d750dd87ef760f1a26a282a5885c27c110cd10e045c75f66fb1"
    sha256 cellar: :any_skip_relocation, ventura:       "1cb7514effd0e61a23c7a36acc1aec851a48c30f73c0505299b1682296767a0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d69b32cae688d034fe8e2977ba692cc6c7600c2b72e1415fd2cd9be7036b64e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e2fe4a0f7ddeae7ea071fb57794514c5ec506fff7b882a28988eca81f8232cb"
  end

  depends_on "go" => :build

  # purego build patch, upstream pr ref, https:github.comcodercoderpull18021
  patch do
    url "https:github.comcodercodercommite3915cb199a05a21a6dd17b525068a6cb5949d65.patch?full_index=1"
    sha256 "ec0f27618f69d867ecc04c8eae648eca188e4db5b1d27e1d6bcc1bde64383cdf"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end