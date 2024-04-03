class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.8.tar.gz"
  sha256 "2d85d4b0af83f90ba60c901fd5e1f100a864e7b958954c8c0649ceafc338a1df"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08d11b7fdc39d61fb920a2ae469aec40811d0c3f7c95088a79211176e1b38494"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4257618d9b7949cf7d3d36c031cc2dbd904bc87bbdbb0611c45c1d9d5fb07db9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cb730702ee35b29854c87e807db65f442653343b3892b2d75871faf9af4307e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f51a227c4b00be678855641936105c5a6d46ae7c52aa933187c9c326bb19c41"
    sha256 cellar: :any_skip_relocation, ventura:        "6444c633b66f02540280ebd0efd02e24e84a305cd553c111d65822a4532f82a1"
    sha256 cellar: :any_skip_relocation, monterey:       "9f1cf2c868f0e7645474af1f677acc2b04257bc6a3e86bc372339c42326fe3dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "530e0cec864db4aa6b3a690aedede86b1e8503da6194fd7c9f2cf6998a5a83ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end