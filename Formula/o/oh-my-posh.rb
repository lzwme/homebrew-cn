class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.13.4.tar.gz"
  sha256 "95210739e007eb8be6092a5d7c42e98ea00e71f4c7439d89c690882de4717346"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a750dae51d59438d99834b23d5ed683ad35c8ce44792bbe6db30f112a4d75f36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f50a2f3b32e85a68e0ec9ab58157822fd5884d6fec779bd0f55c9b10267024cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5658bddd82c11c3b5de27d7a09497d06c090c70afc7796824ca211e91ecb3fcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9eff67a20ed810c6e2680f9d6e0d9a1d4269976dc047289acf3ddef134b1411"
    sha256 cellar: :any_skip_relocation, ventura:       "61fe639708fde2f763b6f985d32865f69f661f6465e4c76cc9a63a104313b0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6128c3613d56d6cab54cdade6d64a0d3c0841e16e387638f3c6762f92d80304c"
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