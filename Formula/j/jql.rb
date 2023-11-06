class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://ghproxy.com/https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.0.6.tar.gz"
  sha256 "3f07a90308a27474be24478b967089ee0441155021bbc1e9f443c498ad6b9cf1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a0e65f32b5a5ae333c5d254a6fddde147991036f7c7c28ec48ea1b3f52a51cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70fc2e5540e568544b40790ac7e2afd8c5d03ae5bdf6f79ef5d46106689e07ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "537c794b9f1882407ae1d492eb4097bc7a55d5143a3153a8278af29434254660"
    sha256 cellar: :any_skip_relocation, sonoma:         "d13639587fa5f6c2776792ade6fe91d1997265de5672c029b4733b07960325ab"
    sha256 cellar: :any_skip_relocation, ventura:        "127bb35dd52a07a813ccc05269aefa052ffceccc0a948861b5443e5ab27324a3"
    sha256 cellar: :any_skip_relocation, monterey:       "cacab9b90fb86a8ee79c4e780d55cda1f3ea84afdf0838e190e6317ffde7759c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ca586603918f3313f65306f2182e0f56d4209717d9c20cde13dead0709438fa"
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