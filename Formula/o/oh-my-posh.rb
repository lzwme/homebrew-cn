class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.18.0.tar.gz"
  sha256 "2ba43b849e9b06cc87cc4127dd3faae5caf359ae7c9ee617e4c04a1e9e0620ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31cdaf3368beaa2edf2e4dc57482fb6feb0db25c433207973e259a806ce71b6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c09ea657d143c8085c8715e9abfbe7137d61e29121ba1cd1292496d00852fe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e1940c208e039c689aa6bfba099050e2a4e4de4ab5e0873a3c45a0f69fbc054"
    sha256 cellar: :any_skip_relocation, sonoma:        "20eb96921e286e0a734b2283726fb96ca702fc587b0a5277e780b3fc4c68a2ef"
    sha256 cellar: :any_skip_relocation, ventura:       "f0e04262da92817b0d0cb6a25bdcaa68f199fc8468223f8c5e1a1b1841fa8535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb849f278bd3321f075985f9e793d47f18874ed6263d57edb9174393006b0b8"
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

    generate_completions_from_executable(bin"oh-my-posh", "completion")
    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end