class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.26.1.tar.gz"
  sha256 "2ed120402b5e420a3c47e27df12d286ce323124257b2aff5b617b8cdb3321ba4"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5afd4d07e530133454750732d87467bd134e2beb297bf1a34d50c5d989c67f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "079807e60c77b7879146c1e43909349cdcc915b34f615141edb2aa7c9b8fcb10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c27c79b550d765a7b51177037654ae54dbe86ca56c049812b618c8139e1b0994"
    sha256 cellar: :any_skip_relocation, sonoma:         "12ee06215f003cbd293febbf47dcd0288403929df0b3d7783867e3fd61d2ff5b"
    sha256 cellar: :any_skip_relocation, ventura:        "9a9537c6f6ac82e65114e8b9631ee416534dc7c4ec5800cbc6b40dbb53f8032a"
    sha256 cellar: :any_skip_relocation, monterey:       "2a643d4d96cd0411a13e2724374e4a8961ec0f790cef6fc0ba3ce2d0a203e997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "504a44f2b5caa8eca370eed6d965c695c12b01516c4888072e877fcf63235060"
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