class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://ghproxy.com/https://github.com/yamafaktory/jql/archive/v5.1.7.tar.gz"
  sha256 "e0bb7e8ac8e8776adacca694603acd9efc35e76315c4aa6f35ba9641d3967a89"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18c564dde7d32a01a5fac141ba792fedd501b08e10f700be440ccd2d2783bb0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d2b1fe2a36cf590e05db2f60323afaf0e153232f72d7b0c93c43b98d3ae8b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5d6eb209472f1dc33208494e9385ae79713815a134592e9d543c3384e03d08b"
    sha256 cellar: :any_skip_relocation, ventura:        "f7d583e0142b4196964f891adeef06fd5a314af511960d99383019e8b2a9d676"
    sha256 cellar: :any_skip_relocation, monterey:       "7149d582a5c2c51ce910d4a4a878f5debaa17801f004c381b0e0cd6644a4ff7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b5afb9880e13abb95f9e272deedf09da688d08f34f66c94221a2c65d79a35f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "093fe93d960d40f5af0c838ce26797dd88bb8ff3d3ce4028f2758c11a458cc58"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end