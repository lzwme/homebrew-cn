class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.21.0.tar.gz"
  sha256 "7861c9da164918a067df34a1876c4e1e966bbe40eb2175911ec8beffc858028f"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "267b351fd653a4b0319926643d07e12d65ac2092f31391eeb2cba2e83aa8963d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4db39c7ccbafb5b63f5d2404aedaef1ef7aad44ec45d6527ede5ab5fd012a61f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7273e92fe926eb3306cd782ce1dda785a84a3f1ae48567c57d0179272a38632"
    sha256 cellar: :any_skip_relocation, sonoma:         "7731bcd68e22cedc46d991dd9f2bf2aa6440f101bf926b471590d260135e9075"
    sha256 cellar: :any_skip_relocation, ventura:        "244d303527f9b61429c49c9d3a91dae548f265b1d1e56e4cfdf18a7c2706bc05"
    sha256 cellar: :any_skip_relocation, monterey:       "0c732817e4e549e8723f716ac23b468ef70c91337488e98ef9b22e67da2e90bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f75f19074c67abd3da2d7f0c3e4b618ace4008cfcecdf787f4b341dc197f8cf1"
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