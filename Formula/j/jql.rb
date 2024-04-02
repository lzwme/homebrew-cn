class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https:github.comyamafaktoryjql"
  url "https:github.comyamafaktoryjqlarchiverefstagsjql-v7.1.7.tar.gz"
  sha256 "8af367a31af3f9c505776a62c943b99856e2c9833409e1acaa27af8b4c949480"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyamafaktoryjql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "719b8939d9a2f65a51c95e83b43ae934b78ecbf0d4f3a0762e1a302f7fd16f58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51220f51c8a10c84bcdf31cd716c412e019e5dc6124f9973206938ca4fb28605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1989959c3fe9a4b066506b0cc269a6494e4f83affed0f4c471dd29e2a161c135"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ea2c949392007f20258dad49481467d77a1fdc80969a1b757aa0b8385ec03ea"
    sha256 cellar: :any_skip_relocation, ventura:        "d513069ff8a7f429936b7711d8a4e62fa8a83a941c25f31df208a4dee2c3b0f1"
    sha256 cellar: :any_skip_relocation, monterey:       "89e1c757eb82c06b601e7df86df542849772816f7bdf12bc852c8f0f4cb01856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70213ad764bf308cf79443797d5e04fad07061be5054e463ae9af80f6fe7faf0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesjql")
  end

  test do
    (testpath"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end