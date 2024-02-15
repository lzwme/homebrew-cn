class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.11.1.tar.gz"
  sha256 "8d9ef5cdedb06afc3a0bfd28aedd323cbfb0135f6de3751383d3d25dcf08d8cd"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce4c6df420f9807f951e1473dc9977f13d89d54d55b051b55ee1e2acff3a28fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a81828a6cb7fc6644e90a9eeee4a3e647993804005897f766fc6cd4c973f37c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eed1c4a5ae6df0ed2461c60be088dce107bd48efc9b91e2ea50ae6a4a14952ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "94a47d9f4589decccf4502e93ed88d91715938fddce4dcc41da7f77e5da2e77a"
    sha256 cellar: :any_skip_relocation, ventura:        "8ad59988c9f3baad2ee3eb06900ebc4e65594872622c30939c475de9bf1f3e39"
    sha256 cellar: :any_skip_relocation, monterey:       "22e261742d06bdfb6855525f30b567c446e1f73bd9165237b96e978cfd40f1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b40c045a965f7f0fec2e98354fa2ae2ab1226217445e37c0425fc670ddc384a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end