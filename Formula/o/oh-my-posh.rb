class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.5.1.tar.gz"
  sha256 "1071ec82f07f9fb0d896cca8cde8344fb183f671f125b0055bda0b691641742d"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8e6699a248ce49b4b64df1f726e272d212fcac76aa1a2a8cd3f87e1310f6f8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d0a4f650f59bf965067e4700119c19f1b5e4a32656d8e77ec521a0a910b3ddd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c159c1701def7151da0492a22937fb0c9f4da2df0c0e4bf7f550fa10c479cff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2f492af8997a77d46b14ccb667513f77ac24a2a856b95687f89957257a88b5a"
    sha256 cellar: :any_skip_relocation, ventura:        "c8e0685b2262aac9f4a3bb2f4e671b0e17d37af85b50004d98c575a0f21e6506"
    sha256 cellar: :any_skip_relocation, monterey:       "fda8b635851cc27548107fdb6f482caaeea1a347a6ae16781d3ff64c0b202980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d025102b389efd7244cacd2d7e359fc4c6f4d522b4ba6e95a3526c4d878a716e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end