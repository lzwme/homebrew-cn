class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://ghproxy.com/https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.0.1.tar.gz"
  sha256 "f274bdbf918d3b3e889cc3589a161ec2931b7fd1668b1fb4550356185b9fc4d3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0243e7801ba307bb901fac4d63977b3fe0704630d23727a99eccd21e0488399c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac4064806db9bf47a47f3070bfd17217533717879622578ec03c2e6c3932ec87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb5a3259da6092f1b609e29fc040205e3a133ce7725e983ff87811985cbfcc5f"
    sha256 cellar: :any_skip_relocation, ventura:        "32e4fc205d2b9854bb1763af23b97c37bb60c7115988eca297b3570e791e95bb"
    sha256 cellar: :any_skip_relocation, monterey:       "57a771489df7b3b0496022f40b66f623ca506cc685510eae4d5df610a868c173"
    sha256 cellar: :any_skip_relocation, big_sur:        "490c7bc6a7d691f511c90bd332285689745c1f4c5fe55648f2d7e0db91e06810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a25c471d63477b6bdf5c6854b952bd3e779c4942490643faaa1e7724174a9b64"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end