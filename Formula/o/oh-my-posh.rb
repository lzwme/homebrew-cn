class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.5.2.tar.gz"
  sha256 "d414148f055b8e0d2a5de7f9b1573cf8aa1ea6c4f9626e483bf9731c532aa994"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b30bbc6d2bfa78d12c52771ab9cb4ab17978d6487d4893b5ac5ab1a8ec7a7095"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da8ac92b075f9c95cda5570eb8d5b6ac36fa090e715fed812ec7696473309be1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad30a0164e54e99cafa33d8243c1ce89bc5778e15ea9208a11b4d7456625f1b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "39b792445d253edaa3d84ad64c1ab98e9f4373663fa786bed2455b6fb0f238a8"
    sha256 cellar: :any_skip_relocation, ventura:        "2370ba41732c6098fc7f2aff3b02b2f53b85e717256d3a4e337a8f5e7a09e7af"
    sha256 cellar: :any_skip_relocation, monterey:       "67615558f56900a36dbf846df31eadac76d9adba2dbcedbc0b012f285cdc1393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d724561537c7dc4eb2cc2943418ad9430fb40c44131afa2a9ee5a10929d64617"
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