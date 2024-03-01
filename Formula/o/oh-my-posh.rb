class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.11.7.tar.gz"
  sha256 "e7bb94d3c53e0d244897d89da202c8e197da7d59a2ddcfc23f49dd9e0db923f3"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aee54c9e463bd1188a0fa4a8e17b5696eb8c85a6f01b747909d3abf2f82e77cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80d35304afb3f313ebf9fc2a20215a5bc2b4cbf134b23f277e55729cc7037553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51c15a6b1f5845dc9435aa63a68060f61759d941fb24f936893d58e7c0c788dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "c21a6d183a2a0cbde7787f332fafd2a63ccaca109f13a2a6152a6c5307168174"
    sha256 cellar: :any_skip_relocation, ventura:        "9c7b85697e1ff6a6fafb9f1281d9ca093196fa8553d7466b2225a394dcbca18a"
    sha256 cellar: :any_skip_relocation, monterey:       "4a801608903ac865a1bb82421eb712869c89339bd86af90df1cf84f4e0edef48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa77a3c4c0cde861136eea79932fe26c28c9258a396015ce1e0cd14dfb087a87"
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