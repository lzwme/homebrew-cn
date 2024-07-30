class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.3.1.tar.gz"
  sha256 "5d8a606e7dd9061a7e5b735d084fb601c00d1a8068b52f343ee2d1e218461a8e"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc8bb11a7eed5117b117d0f9373c86fe7458ca2784ccb97a786863f819c8c119"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9df67e812124c0c656a52f3e06783b8634647cf3d2f1818f6e2a4cb0f5e4bf72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f197cc441ef769610113467af1f409446e30633e32e5c40a0585733dd9011a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "622d038aa7155ce7e7739e168a0328642011abb41f200e559775ab3d1f07cdd8"
    sha256 cellar: :any_skip_relocation, ventura:        "5831b679a19fa82fc9e143f215c59aaf1657732fbd3c2c662b6226fbb08f850c"
    sha256 cellar: :any_skip_relocation, monterey:       "85d2d9c337a5cfefe9f97dadaea538a79a97c552ff06f2f7ee27a09358604140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3fc7e683d1eda7a293eeb389f53b2456434e656f6929b2b21fed8b67c4fc22"
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
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end