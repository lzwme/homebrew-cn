class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.5.1.tar.gz"
  sha256 "65a1ae706724beca322bd93ccb12b650046198a27e11eaa7e915b969e5508aa4"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec6b109ca2911436e3538bb4dd422203edd5806f5462e9108f9b125e020ede32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aaba5fcfddf4cd49fe8f2ee1ed26b0dd43e94de95b4a94bdd4f86a0afa3a215"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2d7ede055e51af83fc8fc5d976f7fdf1f6842657b32701307e812c2d1187d06"
    sha256 cellar: :any_skip_relocation, sonoma:        "d92c4c718c637d32323068998f7febf0c60d7e6cde6f8ae661e67bad99870af6"
    sha256 cellar: :any_skip_relocation, ventura:       "bbe2abef6ca4eee0b405780f2fcb38ebd0fa4f73626608cf72293fdaa0cc7fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c245b788a746e5e283125ef97d95d01ee61572b031c7caa5f5d7f415c30f884"
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