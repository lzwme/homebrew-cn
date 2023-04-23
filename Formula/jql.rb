class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://ghproxy.com/https://github.com/yamafaktory/jql/archive/refs/tags/jql-v6.0.4.tar.gz"
  sha256 "daf2e6e8343ad7eca2b0cc430ae08c8e970f9277a8eb62e06a9781ec4d057216"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6443ebbff88f6a110ef73381103af26ea039ccc23c9e5ac9962bbd5c6a1b8535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99b0b88245a0fdb70b06e11a6cc8c843538b8b6622af5e7b76f80a0a7c85ab0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d58d451fead9e39cea86a172f4aeea3d648b8b9156eb4473417d31f23cb0ca53"
    sha256 cellar: :any_skip_relocation, ventura:        "d6cf90b99b396f02399071407a61491e2677d84a9b319b5d7985feb74c2a90f3"
    sha256 cellar: :any_skip_relocation, monterey:       "14b529d8cc508e330b06f7320a54ad82b658df25ffa67461e0b4293c62387084"
    sha256 cellar: :any_skip_relocation, big_sur:        "602fe877152c3379d8e47bb7f22737ac57b5033229872191c025146aaf1ac299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f001005db32cae72407dbd51cc6783fd67d71f77495056480649cd40f7db161f"
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