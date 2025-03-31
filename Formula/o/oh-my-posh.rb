class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv25.8.0.tar.gz"
  sha256 "5ad0162e551d7fbdeaf3353a49ac3804aa1ec160bc95c0ac596e4a4ee5d5a7a2"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ee126cb0ae054a023bf15dafca570929008afc1aab18ecc72a103541332980f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cb6a31d3a8b39393ddcfb56493933709cd2a0bc3d0f9bd7f9cd83e2e1836c90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbee46f23eda09a20d1e41118d60651d4dafe8c5fc1e40427ba8c439fbb383b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d509c44ce4c9f53ac9b7571e085ec18e0aa1fb6016ac5f93f5a5db30f6be20f"
    sha256 cellar: :any_skip_relocation, ventura:       "83c89da1b11472cdc2a785377169fd1d188fd9118ca0368896a4b57bc2f92059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701dba18306c58888cc1b12b1c256115173ed9390d116bd8d40da2147cd12da5"
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