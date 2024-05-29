class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https:github.comyamafaktoryjql"
  url "https:github.comyamafaktoryjqlarchiverefstagsjql-v7.1.10.tar.gz"
  sha256 "ccfe3112d85831f5e0fc920a49ed4c97473a22620926678a4b8d5a63b6431f3a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyamafaktoryjql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4f6c726c223689011c9549624bdb51ce268bb2d62cb205f6317055d52e22a66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e680f7d4fa2debc9c2175b1cb66a0f089a8ba0ab64e71ea311c42339e08ea023"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "499a6f49a7cab689f029c990a7d8d88caf91a7f2c2fbb881231cbba33e3bbb42"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d490df54b56001c69c9f038a32b6e001b1a059eb18d12628ce77851adea81c5"
    sha256 cellar: :any_skip_relocation, ventura:        "7b1ecd6af098b8c1bbd0123717726f0d2f21c0d9276e0b3e4698e9ce788c443b"
    sha256 cellar: :any_skip_relocation, monterey:       "f98b9d978249062cd6c39eca27dbdaa497439434d64b48bb072896682064a603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "368114cb76fc3ebc17f92362b9ffdebb2ebae620ee60b82f0a9d9034d90de4ce"
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