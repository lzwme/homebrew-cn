class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.13.1.tar.gz"
  sha256 "472a7ebbd73b05237572e324a21f27851bd75bbf371ec30ebeb621d64461b174"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ce931005396f63cf2b6f1e84009ba2d16c2230307b79e82eb17dc8ef958a19d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18b9b6130a027c8aadad95575225018c77a415c1f547254e4f0ce04f97ab2b8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd2766e80b82849a8ff908fd0c4b704afae606e9a1aa3aa3c72c611e114850cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3d522d7181109908984941f14f046468ff50a768632caa3e12ac662d2649db7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0e217e6b371ccc283cb7dc7303073dfa3bb1aafc927970227ab10776dc27afa"
    sha256 cellar: :any_skip_relocation, ventura:        "a3d936001b3bebf4ffae1a9a4a3b99e90c318c2969913cc976903eee353710c6"
    sha256 cellar: :any_skip_relocation, monterey:       "d1ad04b4babcb9e6a1b739dc840ec20f98749b66cf0340c9906f968ddbc5ea59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f14123aec8c8b3349651b1ee37be7504f5daa4633cda636daa4f9b041b45e7"
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