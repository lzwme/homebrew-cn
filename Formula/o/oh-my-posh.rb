class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.2.2.tar.gz"
  sha256 "a99e59fac0206c098db76d9710d31b2aba45a4aacfa6f1eda1fd391761df18e8"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "705da2844e7284040d3b67ab38693c10bf704d865a7456ec8e8421644b94c84b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cbcd7b3ab66ccf619dae3f44101efbfa1968ac83b5b04d49ba7c27f6497c254"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d9e243f15261234c96aaa69a2eed9753b539e67d77b9ac89b4d3912603c22d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9716332183c4fffb5da63fb05dc22a8d78bbc26699f0eb05387af7635f0232b0"
    sha256 cellar: :any_skip_relocation, ventura:       "e4500d0156cc359fd6ddf0c8d7dfd530e43b0bbf84a992fcfff383f26ed98081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9d0b50e33422fa39d04da706c2cc47293013aa97850cde07992f69971262fb"
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