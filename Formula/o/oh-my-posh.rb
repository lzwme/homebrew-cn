class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.6.2.tar.gz"
  sha256 "fa802486a3c212cfa6dfa6b1639f2cfa5efff8de2b168cecdacbe2059678f218"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68b611ce473c42c28b32e7bdfea70209ba88d71a76525fa29f05a34e676e1d31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73a36c16eb65173a63e2c8acbeb30862d43b6f9270e5a7da3a0cf8863abb7fdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39ba253b8b07615b1fadf5d059371e93dd2a9383e10ebe8d34d916198bcabbef"
    sha256 cellar: :any_skip_relocation, sonoma:         "440141e998fa7882e53fcd8b2f256484d2bf12d7f92d3695c2ba16d1faadbf97"
    sha256 cellar: :any_skip_relocation, ventura:        "890ccbf9010be397301f425242c9f1e99f9d7ddd10e64a305af6ee79bb095486"
    sha256 cellar: :any_skip_relocation, monterey:       "a33d5ebccf0764937ca1738675b93b8eae4d09dae6b15f065283421b02b52cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c516db03515dc1d02239664218651cb4313698c0d6ccc8e5d6036997a6b36662"
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