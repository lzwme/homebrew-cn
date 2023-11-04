class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://ghproxy.com/https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.0.5.tar.gz"
  sha256 "51d00df5316d6b60b22988612f7b881e7b76a80bc2de77e37065479b36937c50"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0252a93431ca67b7ca37d8f45caf16a8fe9d0eefab722b7f0518740350414d93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44e2faae5ec21ed51ad778ed5e27b3b5f3687f42283ab9fa01257eb766bc1112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4968f6d7ef9db5d97a16ac1283ab8d0b659b136e0bac9a3b515d5cca0c97280"
    sha256 cellar: :any_skip_relocation, sonoma:         "cac2b81c788317ac12fb3e3cb8bbf09c52c0657300e21b0c294c1727aba1973b"
    sha256 cellar: :any_skip_relocation, ventura:        "1265c11ddd86ca7612623bcc8fa78c2cec47f9ba2ab9d6f91db16bf62948afcf"
    sha256 cellar: :any_skip_relocation, monterey:       "25ec31ff3c52845af226a6e5054996403d560c6cec25ee9bf5605e31161890a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5efcacf6afdf183bafe45125273ed504eb788adf6b38e389325c2781572a69d"
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