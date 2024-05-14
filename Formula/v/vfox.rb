class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.5.1.tar.gz"
  sha256 "8695abcb56a0a65e430bc2da78d2256d30c56f2b63bd7fd8fe8fe6c0b29c8d93"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80efa0d5f7060d3701783562ea9a7d4b1cfa0386ec05d1c12c2a94d8bbe0b41d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40c06bbe4d9f2467622c69b954eec1239bd029aca915fd30dd765aca41c369a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af598c1695fad66519030997745eac0efbea6ba6dcd3b8314de4ab31d0088cc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "626ce198721e9b7ffb486d062765567ce32b183147edfe79c0db6e4e2a52e196"
    sha256 cellar: :any_skip_relocation, ventura:        "9094a78343f225cec8fc89241206c91da75d8086845f3183a3d28b8c3b9a6ffc"
    sha256 cellar: :any_skip_relocation, monterey:       "40f64a51d8925d800722498cb06fab040478186f5dc252b6595429abe641db0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "404b749e4e618b4cd6e123909c59c2b1ad3f67514354c34409ac0756f6211e58"
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