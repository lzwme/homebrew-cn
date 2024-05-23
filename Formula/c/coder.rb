class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.10.3.tar.gz"
  sha256 "3b63c60a76efa0109f926740a7d340e8dfe06a7f623c73e47273eb60a2508b47"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92a441011d68ae6b3a784a6b49cd66f54016e468507772fca95588a227125f65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15a8498ffdccb379ae0ce328ba346755e5154e03a83b3225d67213b6f25e4718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4c654a4a92d132471c9fc6237a7b136ada9dfa94667badb1ea73ef6cfca080b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e8323fdae3f1d8af60bd919cf2a187b44e65fbcb701430d35bfdc64ce14164a"
    sha256 cellar: :any_skip_relocation, ventura:        "7e425c39b15406f28aa74cd61e66148ba15f49d9ceaed1192522437877b0fcb3"
    sha256 cellar: :any_skip_relocation, monterey:       "1efc5564ffa309602b7dad0b214640cada4d48e2659b633021238de822681f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d5278baafcb56108e5018956561fdc55bcf9b0e79409398eca16e084f71110a"
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