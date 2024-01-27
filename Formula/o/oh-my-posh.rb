class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv19.8.2.tar.gz"
  sha256 "8c74c241e87f345291c688a60cc8e9f30006c0f5f04efa92124c3e6c01de39ac"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40fa530e3a5b18b6c6f7642e25b3ee0e8b9d4d23e4724ce74f78db16ceb1e723"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6988cd1f761535bafcf1945b5fcf582d30d9c6f31b02c8997ed61a2bd180b3a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05f6345e31e2053ed0abf32a4e509428f68ec4f825d9a3a82e3c5a4358f67034"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d88147888b0a5e461ac847e3df777dfc1795a9bafc2d70a0b140331192958e6"
    sha256 cellar: :any_skip_relocation, ventura:        "b78780e95855aaef6fcaf29bf498cc9dc1d9027155879a5b52c22acc72a58a03"
    sha256 cellar: :any_skip_relocation, monterey:       "5feef34ba1ca5cc13f8245c65ce67050f9e1da4a66e12ce33912cef353e7640a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19110ea438d6c56bd92e10c1903a585d8015f568f129af002381c02df32f0cf8"
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