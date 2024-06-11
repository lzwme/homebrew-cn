class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.5.0.tar.gz"
  sha256 "e29a770449f15e8d8dfb99e957dbbf3418ecfadc3507d827e2ac2bac9c3e17b0"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98c4d4a3eb90d98c8e6f1f96477b3e20b1fb6a7e8927b742a7ce5007f8d1fd6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd23724333efb1fff5ebe21676331cb281c7beacb6d7db9adb906971137a3049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0532cdd568d28ef4fa50a185c1ec688ed6a107336f6e150025df9f25c392b61"
    sha256 cellar: :any_skip_relocation, sonoma:         "82ae108248e3f4198cd0898ab77ce736ca51a47e8fa91d83e40d232d0d76a6cf"
    sha256 cellar: :any_skip_relocation, ventura:        "c80a48a79a9a7ca004b17c37077ecf8c942b89732facb5beffab8b64b904a99f"
    sha256 cellar: :any_skip_relocation, monterey:       "7f25d1d09941a7692a3d1b27ca87d0c552e3a31f24cdf70e1243d1e703e515d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e19ad439337492b43a601be2bff351ac6c141140da8c01e9938a31833607c8e9"
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