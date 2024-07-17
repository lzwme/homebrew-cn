class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.26.3.tar.gz"
  sha256 "b28e667ecf052fa2491a972f75b82b3c8d1d483ca2d9942e913135eecde3e46a"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6c6097324bed9b8e15e3d6641bc621d2beee3b8d62090592962c364048e3314"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df5bbf29316e87e44089143beed3443fb508a00880c2794874046fce5f7799a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21cddf868366ffb523d043103c7ffcb540ea574b9ddd937b9f7679dd97b9d899"
    sha256 cellar: :any_skip_relocation, sonoma:         "9add8147d1a281e663f07622c58f7bcc167a82937825983a31f567d2d4a30d68"
    sha256 cellar: :any_skip_relocation, ventura:        "33ba9c2d82acea02db2f8e1975ab2649bb8a4eedea6297c35f944a55d4dd1367"
    sha256 cellar: :any_skip_relocation, monterey:       "8f0a6b146c904b9545ef4853dc8d99c32c00fed19832d85f2797c290cbb90363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8522f2f8c6a736ed86ff9a7958f34f629bda09113e49e020c323146f91dc56d"
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