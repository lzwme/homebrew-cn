class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.23.1.tar.gz"
  sha256 "f1de6a71170b10e47600375732b9b16ed5a35971d4a4ce977aecf35984093b04"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f129be7ca09e31a3a0b27baa69cdcf75f606fee569b7a09bbb0b33701aa4487d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dccbde1472ed05f999109be30db89862064331b23933987f4ba2cb56baf4551"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3169d7dacec0e9b5cb36c19037dc9b7e35e23753f0328e9d3de148ee17b55af8"
    sha256 cellar: :any_skip_relocation, ventura:        "f6e4a67934e0603f8c7a7c693ead9e31e39d5380920ec4b076d4d7012551d537"
    sha256 cellar: :any_skip_relocation, monterey:       "183c2acb5fcf3725c54f642e2c20450add784c1ce7c63299f33f8b99fd8c03ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb3bc68067a405747edc1f5c3daf27303bc9c5e9c9dce9bf1e3f06e4491ab614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33c4f7d50300f25dd80b8d1739d08aaca6a6890a3ad4b3fa01a8d82143c9a9f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end