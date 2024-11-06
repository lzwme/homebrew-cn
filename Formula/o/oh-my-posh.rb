class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.0.7.tar.gz"
  sha256 "fc00f22a6ba067a932098e881924faadf4c7a6142f235c65e51c23587df93608"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a49034f15a5259e59cc6f35b7c3cbd7f56a1862ee99b4ea1184ea706cfb76814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "945ffd8e0fc48e9330d75a759a6a513bd1ca7690f211375c20993095deb02ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73c759d4dd6578131e167174ebc12a56a95ac5a91ce63fc31ced4918fcdb440a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4618f757cc3287b8fa3c531c2358407e60c540dc01eef68e26a2982895199bb9"
    sha256 cellar: :any_skip_relocation, ventura:       "ac0ddec156c37e981843b2a9668335b33386434122648c38d8f1aff48e709b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "808359b5d0be2fad26831af56e232cbbfc2f0568a1ab7a4a1339dc89be3576c5"
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
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end