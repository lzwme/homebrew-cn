class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.4.1.tar.gz"
  sha256 "5bc3624c32ff7bec1294a9cd0fb9112544f9e11c2402682ba71bc872f1e9870d"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeaa1a408c537e86535eed9385df81d3e0dcc0e6c1395fb2b0e173f6e7147f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "402b1bbb5925822d28d58fa5da8197b176ac75f44b6363e3856c27670cf81966"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5141465a28b8bfd450b88b62c81465bb36454143843a507cffce8a1015e983cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f31d7a3e92e049a7385406e8cfa6b603bfcac5facafb4391746f8acf95623f9"
    sha256 cellar: :any_skip_relocation, ventura:       "0288defd914a71a1311c6c0ddea7a782c1f019fc3102eb056bd4b077e851d92e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3602c95844759fd2fa8704a672e28e4f46748d3e0d88bb48e67b700589883618"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
    output = shell_output("#{bin}oh-my-posh init bash")
    assert_match(%r{.cacheoh-my-poshinit\.#{version}\.default\.\d+\.sh}, output)
  end
end