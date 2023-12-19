class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.15.1.tar.gz"
  sha256 "22d4d6332036f69b621904498b4e309f07874160c0d218c141c7300746de9ae0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1feaf91eeedc88bf6cec1958a6d6fc4357ddac449c980006ed21806a46cea9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51aa38e1497d0ee6c8946bd39e8c58930bc85de84dff53bc5e64d4c79dce41d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c904851d9ac118ff8f1ad6df92fa118f4ff1fa1840efe764933abf399524ec2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebbe7d68b581b042887d18c635e23263d7dd878fc3e1e570eab9f074845ffa5e"
    sha256 cellar: :any_skip_relocation, ventura:        "8df391c59acaf866870f237f5aaffca1a86268bf7c347a36bf9e2d53a15e4f82"
    sha256 cellar: :any_skip_relocation, monterey:       "e3fe27be4b6a42a637282804dcd4fb34f4c2e1e19a37aa8555e9515b08fbf40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d47096f7be3f3a33643d28b57cb15d408f28fce949142434227accbcf959de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system "#{bin}sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")
  end
end