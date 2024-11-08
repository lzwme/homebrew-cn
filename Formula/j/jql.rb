class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https:github.comyamafaktoryjql"
  url "https:github.comyamafaktoryjqlarchiverefstagsjql-v8.0.1.tar.gz"
  sha256 "6c1a52d39dc0fcbf183b34f4e4d404c9ccfe6d6180ef45acc82c3746690f1ce6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyamafaktoryjql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8ff39d736b1bbb5975c56f6a378d73ace0f32ac0a2d3880597cfe8aefbd1791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb11fcac45f91837ad9cd9a322df80d523447553a39772491bdf9b1b8766b688"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cda7dd1546ebb128d0283bfd3fdc05e16226f3b11527cc90f9d521a515710f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cfc99841e4ea273bd2cf4278cd10e0486b9b7df440a580ad78c89ef56e67e6b"
    sha256 cellar: :any_skip_relocation, ventura:       "70b6fa6bbb9bd97f0aee96d98795e833d832276bbd0a84a61b5e47fda874784f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ace2db77a87b479137a165fb039461bf8b6b069c09548fa4fa8a95c83fb5fda"
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