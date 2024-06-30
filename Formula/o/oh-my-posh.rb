class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.17.2.tar.gz"
  sha256 "458e03804fa633295137a7e91515101f458d949329fa6a5e516d1753436099d6"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68aaf838e84c9668e8ea82068493bf0c5dc6c30726da59b6ae01815cc388a12c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0ea6f6aaf248488ea60800d5c733e627b75146e77c481fa389810d3e9b1cf04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c52537d6bf9f8f25f4b35a7fa4f3ccf2933a55eedb23a2bf8eb631b9d17e8e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "622c7a9c15149aa9bacbad9f24474ec6916c2c68aaa6ba61a23dceee00718b2a"
    sha256 cellar: :any_skip_relocation, ventura:        "f0da3820d71654d4de4113db625d022cf7e437d29b0e5e9ef9fb29b61ba3c5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "56a17708da4577903a620afb0231496884486404659ba2db055c2befb26ab075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a58bd17775070ea34b7ea397e6e6d788b5189f82251a1bd53b987711f1ec2918"
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