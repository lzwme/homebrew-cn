class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.21.2.tar.gz"
  sha256 "83799a1953022a86696024d9026354070882b8b4a78917c7abf38f34c7299255"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b283a20f42375dff1601f7957229d27cd991c175f7c68f8f71b4610c4c0f043"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddcf6db1d02380f8d3f1956c367c67cac8b1a85eb7bb4457faef4af469debaaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3687756cbf6515d9a72711cd53b059845b3c5875880d6fe2ac578b537b288f6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "99c9a5cfab4f1286cf56c527d9ec13e12d697708a11e376a34f62836028a68f4"
    sha256 cellar: :any_skip_relocation, ventura:        "52422d494cb31233912e45bc80de75cee85a6940eb4952836bb913c5b390d7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "a850baaf8b1e6ab4e4fc7257655b7d42a43dd45ead2a2f190df2d448afb40bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf91f21a88ed0be5e693b85064d423da0a30cfb3a15d8a7ea6a3263db36139a"
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