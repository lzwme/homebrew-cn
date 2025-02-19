class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.6.1.tar.gz"
  sha256 "c1b37d32ce599d9c5136f9dff3c4926263964fd29d20e2c586bb10d78c668a4b"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af79f8aac78dc39f6a9b1a106d930d9e9b2e08a4d44607884eb0a001e5d8c71e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af79f8aac78dc39f6a9b1a106d930d9e9b2e08a4d44607884eb0a001e5d8c71e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af79f8aac78dc39f6a9b1a106d930d9e9b2e08a4d44607884eb0a001e5d8c71e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f3d8d2ef115ead07d2df006b81ba601d4b69f0c8023aa93a1dad79c9df0639b"
    sha256 cellar: :any_skip_relocation, ventura:       "0f3d8d2ef115ead07d2df006b81ba601d4b69f0c8023aa93a1dad79c9df0639b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5badd71c37ee37e0da41ebc327963c23682b4f34f2ef2eb9cfdbec1d53dffe0a"
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