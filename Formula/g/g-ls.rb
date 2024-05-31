class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https:g.equationzhao.space"
  url "https:github.comEquationzhaogarchiverefstagsv0.28.0.tar.gz"
  sha256 "ee6465c34b1cdf261c2f7831972c1e81faa6c93cbbb2c1175c52e2a35b869a3f"
  license "MIT"
  head "https:github.comEquationzhaog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92a7ecb082dd83e3e8d818169c84938f03d2d4a7be17e0c1f12f9fd08767cbce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85a3e7688725622955e36b713107f54a7782f74eee107e5154ecf71a757dbd61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dc0a9d7ebfb91b94f1fab12df5d4f1bd11188e7c05d43b18f9d96ad2536e45c"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaab13684992bef06b2d2be706a2e6bd5a9e654d8f974e185cbdad6fb03049a0"
    sha256 cellar: :any_skip_relocation, ventura:        "dac405340042633191900f426ffb03ea51b2b947137c9536870a3fdc7473757b"
    sha256 cellar: :any_skip_relocation, monterey:       "0dc010cb498ec1e02af8c4da00e1d3686b347d99781ce1106f9413135eb0b182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a1429a3522e7a251840042a6545e61081942e75b71fb503f6d9d15e519a539d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"g", ldflags: "-s -w")

    man1.install buildpath.glob("man*.1.gz")
    zsh_completion.install "completionszsh_g"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}g --no-config --hyperlink=never --color=never --no-icon .")
  end
end