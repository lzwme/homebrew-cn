class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.7.2.tar.gz"
  sha256 "307813d9994ce17aa2a987b4176afe7ce6795df0d71b473bca61c3f626d83357"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88f71ebe1dd7ecda347e9d51e50abf066745116d02d7ee42cdf69ef3d457a413"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4265736c9fb8ef3860143daf9456645f2c63b3f531e344b789bbbc841f706c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6880303dd4ba3af45e1f9efa7c5644dfb913c56a6471da622cd683c1b22b323"
    sha256 cellar: :any_skip_relocation, sonoma:         "9236c0fe7deac66e62cd7bfc7e5ba66c8cbea395ffd4e05e0343dae9e31f9977"
    sha256 cellar: :any_skip_relocation, ventura:        "a9cd6f16b9435c2057fa6a08da836ab9571795e3d89508ace837bfdd696d0d5e"
    sha256 cellar: :any_skip_relocation, monterey:       "00d0c8b23c95ca0c586170dc176a0bcc1ccb597bb9ec3a83c237f9e9dfc259a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78eea8e754b25b3053e59f7a7041847da9b982c64c66387a0b91907261d730a4"
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