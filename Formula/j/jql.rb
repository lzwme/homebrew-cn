class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https:github.comyamafaktoryjql"
  url "https:github.comyamafaktoryjqlarchiverefstagsjql-v8.0.0.tar.gz"
  sha256 "ca43b13cb3f9c9c60c776450b83a838a73d1386002fd9365a76c6123d5db3bf0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyamafaktoryjql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db9a19d7349906fac59ea9171506f6f9e5f36b76800197ade192164b9a1dd82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cca280a2589b3c220554e48a4c79c7226fe350bd2426969a3ca9476b9d033d16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb9e836365419a22286594a49dc0181042bec4cc117a2611d7b2b11fa3c26edc"
    sha256 cellar: :any_skip_relocation, sonoma:        "33f4cf3f7ef3d45833d2c43bed09688420fdbd43d0149b700fd9dd54628c3d9e"
    sha256 cellar: :any_skip_relocation, ventura:       "90ed29b52236c84df3eb7e38b3f8fac5fae9e6811bbf1587396813f0983cccf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f26d6c014ea3627c1ff4965684a01642217dde370896561d70bf43bce3c45a7"
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