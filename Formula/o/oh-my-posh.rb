class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv22.0.2.tar.gz"
  sha256 "a392db3c08e57af170d7f1d39710d87aefebc33c4698d89d8375c6d1c90a8a10"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b16d1f39f4d0d793877f2ee82a8f58edb8dbbb6f60c5e2ead34aea316a2391d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cacd5a94f7ddc8a3d1f17cc756a05e331a7659550cc6ac75a5498d03a647b0b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1633606745b24de3383f402b762728190f8064e9839fe883708fa3cfcffd57e"
    sha256 cellar: :any_skip_relocation, sonoma:         "013caf9c063ac3616cc3cbd090ede4a88aa003acac5815ab51af291df4e4437d"
    sha256 cellar: :any_skip_relocation, ventura:        "500bf275908624dd98e1d2f84f1b3f423cf73714183d42c5ee10ac70f3b1f237"
    sha256 cellar: :any_skip_relocation, monterey:       "347de3d4273c054fcdec2a311042a0a53f94af14842a3c59c0018aca18552305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a65b851fc4a2eac342e4d6e4f279d0e03a3c2c8f5da38a3624a9f5ccf0965318"
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