class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.6.5.tar.gz"
  sha256 "8c0653d969fcb5b628f7ff04b0340c3ed69ec72959e84b4e12a8e26810c73bdd"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6313c5385e6e324fa3199b4d444348a30c90905da80fb1f2f6071dd7ad613969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "146cfe4285194dd705fcc6774ae65545bb72ca45d5c3649905a64468b5e433b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "421c2afd80bc62d7c3fb874ac5322de75125da869ba98e570d586152107c297d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1225facef14c8b5d6c48503cb6d63833e7ed65796f9338b83297ff849c46b04f"
    sha256 cellar: :any_skip_relocation, ventura:        "985ce6808a83c3c344595b11d0341df05403110d500ee814d3ac310479b1238e"
    sha256 cellar: :any_skip_relocation, monterey:       "bc8ec60f6afe7244dfb564361f4fbf03b1bb7cfa7b53982f7c697a2899d458e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6c8149074876df0e65a782e03a38ef5f664cc8eb2384fad0b68458899a79f32"
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