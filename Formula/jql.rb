class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://ghproxy.com/https://github.com/yamafaktory/jql/archive/refs/tags/jql-v6.0.5.tar.gz"
  sha256 "13769853965f3d2f42815489d952db526594cb953e1e40dddfaed09c2a1fa05e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db3d8bc7d6d4acf2c6c60ea9371b3e0949632e8ce926281108eb19af535456ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51e392af3211a90963485d50a5b0a67a9bb7d4d67fae2e6867c7bc32b8a17661"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76d5762a7180058d5c206bbc4463132c9d831cc51f758f39cf81d630eb3262d6"
    sha256 cellar: :any_skip_relocation, ventura:        "79fd9fd0d732a4872443b89322b6fb1c9381fa1bdda6f1e4e9d6b081f9eb85ce"
    sha256 cellar: :any_skip_relocation, monterey:       "750c9cfc4c5c626b5e9b5d8f8c8754a1084cb35b5a409e7f7d75a4f3e4f9e25f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec8de4ad668ac3de2a6d3c4e20f3019093c355656f56f80dafcd14c5839b2c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c62fc90da8bca76fedc872b4a0343d954e4fe9bb1c5ca33ad18a3c758dc9394f"
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