class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.6.5.tar.gz"
  sha256 "667da8545a426a8744c0bfd1b8d00b996404d406bbd33babeb9d6a6a9dd43bb2"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46cc9bebcfaad4b9fd90098b36c345240f248bd777e1a3ac056113b22bd3f4ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb5386fe914e8a75171715b697b1a3dca1c143706e31e818aa1f092427e09013"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a70711a1d24aa807262c312b0d8870b322249e53245806b0c1518239c5d1a49"
    sha256 cellar: :any_skip_relocation, sonoma:        "b06ed7b991d57e914ad42307e2348512df754f34f85c5adaa98de5cfee89c631"
    sha256 cellar: :any_skip_relocation, ventura:       "38916903141cca8312be31ab6949c8888be44cb8f9036173e0c7b4d5bd552784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ac2c47279a2055f9290881909ee67d5a0cfd0ce94744acf1de9f93b24c9311"
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