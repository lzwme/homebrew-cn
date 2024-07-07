class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.21.1.tar.gz"
  sha256 "8b87202707b0fe4a9c88a605d89545d15a4daec5382af03c440f56c0183a7f4b"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e74375db0d3bba03e61bcf435ec273f56be4c5f2c114fd3f810aabdacdcbd15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "222dceb3b6450a400ce1a9f0381ae04bc9686257f9d9359be61f88dd3944e485"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e1e716eafba0537ace8c12523992ff139efd7915a4dea2c6c9a7588bf82538f"
    sha256 cellar: :any_skip_relocation, sonoma:         "50294e0d888724745724fdba3b1a2d01f1c4b7746b2158f4129053df2be688d1"
    sha256 cellar: :any_skip_relocation, ventura:        "cf7f001056279ccd95892f3c6b5ac2c658bb8926bd06a7069a8b7a2520292459"
    sha256 cellar: :any_skip_relocation, monterey:       "96261eee59264fd014b4e7db381b55589f4b8a4b87381f04001ac226b35172de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b146efd03f4b35bed186d1227f1f5df35fe2bf39a8d4ced35bc04fec4f28106"
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