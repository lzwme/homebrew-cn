class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https:github.comowenrumneysquealer"
  url "https:github.comowenrumneysquealerarchiverefstagsv1.2.1.tar.gz"
  sha256 "0282f62941009ad47f48c78a3d31444b4b50011f5667ddee0c9b31d7d45037f9"
  license "Unlicense"
  head "https:github.comowenrumneysquealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4672da4191bc67857d617ecd762b89f448440cbdf93964f7bfa6541d27b5ea14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c20622de61fc141574b3f49ef6094d6f7469a9f4e4289c1058ca42f9003c825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c7fa6a2a83748dc220d986eb98c5f2d82eb4280efbbed1471f6c70e0b20ca1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4951fca3a656034db3f4b82e397bedf95dd583fde19f729d6777ec1e61e0948e"
    sha256 cellar: :any_skip_relocation, ventura:        "5fc77f2d18d5c9b61acded0b6166f6bc8dec809a2c896883ebb002faca3e0e89"
    sha256 cellar: :any_skip_relocation, monterey:       "dbea662df1308f2b654827974d564d98b9744c9a1b1c00a29bb1c9ba368b6cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "193451a97c2b59178ac973a886b75464e0d1076077f9c5d960be89399892e14d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comowenrumneysquealerversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdsquealer"
  end

  test do
    system "git", "clone", "https:github.comowenrumneywoopsie.git"
    output = shell_output("#{bin}squealer woopsie", 1)
    assert_match "-----BEGIN OPENSSH PRIVATE KEY-----", output
  end
end