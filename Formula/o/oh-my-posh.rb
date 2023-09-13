class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.9.0.tar.gz"
  sha256 "b189499c7b8fa07b10c2566abb0caa52795cc169efd7452d4303b6b8e9109243"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b65db05f57690f9bf9692aa3903704018ebb2313ffecf69b2214605526f81492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4486eb01189f134418c997afe59b1f85f37581790ba1d7fc465cff86f5877264"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00e3819054648a1f653bf84f79c60ba9a15761c0589d616f07cf7b7fe32aa336"
    sha256 cellar: :any_skip_relocation, ventura:        "d4dbb4e6b9ba165ae2d3dd2e3a5280b60af41dbcf4b5a0d9cbe4d7127ee74b35"
    sha256 cellar: :any_skip_relocation, monterey:       "c292902121e9e3fef523d2f85942ed10049bdc55b81d1a39053dd34cca86bb8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cf55bc415096c2e3aa7ea8a2c39bbf073023bc1f9c6d43626a4bc4902e1a2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b8285515832216e909a52064c13f795102df0b441ffb955e0de2917b64797ef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end