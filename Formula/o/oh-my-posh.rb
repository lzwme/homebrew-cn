class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.23.1.tar.gz"
  sha256 "4902ab002995d4083e5b4cc783c3aff44e730f71a5093f4675f8180c47762623"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60f85e28f033b47197f5424bf5cb0c2d4c9a0348eaf497e84e6cd2e5a29939dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c88786a46fd1d280616dfb1060edd617d380e9c63e2909e99c8be03fec1ae00e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "884b15a0c03fc0dc3e72a23b3a4211a18b4f57f687b908d7cc9fe8b4390d4916"
    sha256 cellar: :any_skip_relocation, sonoma:         "42b8efc542d24e92b59f00d35bd5da13950d2b2606bbcf5772dbcd9fdb8ca498"
    sha256 cellar: :any_skip_relocation, ventura:        "9b0500887b3b6c6202fac0f918348114bba0a48524a071f54517a046cb613084"
    sha256 cellar: :any_skip_relocation, monterey:       "17e64a7f016e04fb25cc226639d986cafe08d094aa7f6bfb2fed7ef21d45848d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4ed74647e7e6c262941158dd1d7482bf6a458aeb9969ab6c2e5d9fd03d57e69"
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