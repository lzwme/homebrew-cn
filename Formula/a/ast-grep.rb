class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.25.3.tar.gz"
  sha256 "7ea03c686bfb68482f6fc615c0207f3600d0a74cb16a30de256ac1c6917041aa"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce16c8a8bec6575ec32e3e4348699e7eda59b272f84befbbd6981c9a63d4fa03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acf068abf2ee658a74fa5c97d7c77f0e5ff7486c731ce1302a586b56123c6950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbea2dcddcd7cfe57117e43df42e8b02e868d663bdd05135cfebff09ba9e9abc"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e195bb87b04c6254103d35894e3b14a24f9c544f78edafb4a068c1adff8805f"
    sha256 cellar: :any_skip_relocation, ventura:        "e41b8b9c581b0014d11724d9f0b95c7e6915cbc8def9583a712320024b8c83e1"
    sha256 cellar: :any_skip_relocation, monterey:       "d237264151dad1cedd8dbfdd7f600a05689c2c2a3b1c05a7ea2498ab0cd7e08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cde9569ec81f9eb30fb74edef0c413517ac36f6630b41803f11e7f5395aed7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
    generate_completions_from_executable(bin"sg", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end