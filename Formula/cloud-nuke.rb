class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/cloud-nuke/archive/v0.29.1.tar.gz"
  sha256 "8dc5b93003c627fa6ab06b151881cf8153c14d132b3494c4132edacde28bb932"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74692cdb80bd45ebcd678480859439b2a9bb5b53a53abf0ed237dcec3f2f2ccb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cc7815ab19947cbf52b08fa6d41319cff1ed2259686570f71f5097f46d2a66c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "386994b1f27847f173fdfb5bb4ac7aedcd0028b11c884e276c8b127e24d0c319"
    sha256 cellar: :any_skip_relocation, ventura:        "aab62846fbd6db0eb7ce9e6c9c3cfc0201fba0b311bde354a00e27dfdc18939f"
    sha256 cellar: :any_skip_relocation, monterey:       "422122121fc6f0fab11e48e604c62252bf5e285be7ae3b2efb143f7db7e57d46"
    sha256 cellar: :any_skip_relocation, big_sur:        "f669852f9d6a063ab00fd23363e8f63b7d3b40cf63d02dcffb7a762860d18611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f92262865894cc6305b29059ecc027d2a9768a1c0eb2d1156fc96df979259ab7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end