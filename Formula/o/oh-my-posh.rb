class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.14.0.tar.gz"
  sha256 "6ddd735141916a5b37e2f70784c423c73f981e5d040cb184d64a8c1a94d0e90f"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93fb4b5a55dcd97999e28452e2b29a740d40713fd6d35caf9ef508198d7476b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0e19083299d0879b92c1e03252b97b2a8ad6cb647f817405409341775887584"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "639d749b543832e3aade42a3ac9022edcb02905812eb651fce9d255539e1fd1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f9126e5205d6b91bd0765b6f32ffb2b5aeae3d511f2e93b6a512f825268f5e8"
    sha256 cellar: :any_skip_relocation, ventura:       "178fd064528fb8e7d5efafd568d3efcda1965b597eafccb6dc7493380d72f80d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a9d99a469667986d5c377064d6c6b2d3a87093b7756dfd792e754893bbe856b"
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