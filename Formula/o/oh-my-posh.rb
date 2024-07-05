class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.20.0.tar.gz"
  sha256 "f55014299d28b7ca985d3c202d14b283d68970f0202cb2a7fdaf86087c743255"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f23215d26675a2a9560884c11aac5e2bc7098c879a494a76ff0741adc05e2fb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f01511177fef7d0b2f2350a0141f214161c39cc24276aa10091cabef0044ce7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc08b28e8d7702355f217749cfb9d69bf4d3cdc91c7657f4d46ce616b88c30b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4881fd52550aa84a08605861a93e13a82a03a3b56c2578914262f6e98c98e52"
    sha256 cellar: :any_skip_relocation, ventura:        "da9fee6d66c46a6d53a67b95ba99dd3f09eec4f84098795e1d04291c7a2a9bd4"
    sha256 cellar: :any_skip_relocation, monterey:       "40d5e76ca63838105e436b68164844fa4e2d38d570fd55ffe68bfbec73ad9a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8471cb0e5347d0fe1f8566bd41b6120d16c81d7ac1393a8550ff83ebb4904659"
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