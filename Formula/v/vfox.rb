class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.3.1.tar.gz"
  sha256 "789cae4218a46ff1aeadf22b94c0b8ecd394088f0d3440e7c58293d4e53219b9"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9bbfcb5003d4d6992701caab65da3c99d25f5eeeb9fe3fb48c4365f5685acc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2b4aed13309d4a862d8410665aebfd50b618470ec5938a4795f0fe09fdeb5f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb07929cf42d07055eddf14343721d5f3d6a461ca29567958b00d8a31c13c167"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec7ab599914dd15f0a39f37ae3b89b82d6ca2f6ec7b7a5845bd5f70f9f729ac7"
    sha256 cellar: :any_skip_relocation, ventura:        "5a1165547cb7e708b491fdf21f9c5dcb47037b78e0192923262f2ddc75c6b819"
    sha256 cellar: :any_skip_relocation, monterey:       "285afeef7d8176ee24cb8aefa2e4408195eeb432408cde8565fb002f18814425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5605c29fb2d04e3af5e38ed2d887f3a627909126d8b0edfeb17c91b094c14375"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completionsbash_autocomplete" => "vfox"
    zsh_completion.install "completionszsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vfox --version")

    system bin"vfox", "add", "golang"
    output = shell_output(bin"vfox info golang")
    assert_match "Golang plugin, https:go.devdl", output
  end
end