class Graphqxl < Formula
  desc "Language for creating big and scalable GraphQL server-side schemas"
  homepage "https:gabotechs.github.iographqxl"
  url "https:github.comgabotechsgraphqxlarchiverefstagsv0.40.1.tar.gz"
  sha256 "eaeca9ce9c4d659d3ef9f033d54df9acd0dedc5785dac27a5756ebfc7eb15c6d"
  license "MIT"
  head "https:github.comgabotechsgraphqxl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34aff89044cfe6a4bfd04fcff03d53cccc8bfc8d0f1edfb07392b788f56d8dcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97e4e1fdb3e9f3ad63a935cd16b14b78e880fbc3b1db7d0b4ed17f090fbc6b28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81265ae8a9194dc65c5eddd22e36ef114d31aed47930b1a72039052c7b3b3e05"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6a3666d43942c295a6f7c206c5120c1a28b3982fa9dc9e611b5aad156107263"
    sha256 cellar: :any_skip_relocation, ventura:        "4538fc198c80c0e3220b1b16e49a2529855aaf9ac3e186a6029b48c48d589cc3"
    sha256 cellar: :any_skip_relocation, monterey:       "96987b6c99c6283f618b163418cfc6a2928dc647817f944dcd7ea63cad956946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f351beb2919c505bbb37b66ecf893889143f03a1d77169680b089d3d21add45"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath"test.graphqxl"
    test_file.write "type MyType { foo: String! }"
    system bin"graphqxl", test_file
    assert_equal "type MyType {\n  foo: String!\n}\n\n", (testpath"test.graphql").read
  end
end