class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.4.0.tar.gz"
  sha256 "183c6bd33afc3a59b003ee0ee24f5658bc6c0af3bd667be072d51fbd9c1e039b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc38b55e3a3fcb90b5c81d978a01450d37cc75dcb660b6dc9ef228cf98ec8908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "056a9bda09ba3b5f3d763563a22434eefe83761919f882c3ab2ed4332d6dbdb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80834d9858b1d0fe595032798ff3d5728f2e11669798397f8a385328a24991ed"
    sha256 cellar: :any_skip_relocation, ventura:        "1423518ffad49ce822a1f85bc9372c060b7d8d5ef992cdc67cc97bda0a8e9918"
    sha256 cellar: :any_skip_relocation, monterey:       "5b7d2993729b3c764eb644a4c771e6a70c4a8e22bef2ce66381bfd3165fc39e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "33e88fc192377ea5c41fd57bb8a881134c181a782ce72eeefa94baf27edfb43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb4712cfa40c1be46e491b018e6a0bbdc87256642cbcd7daf11a1c282c409bf5"
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