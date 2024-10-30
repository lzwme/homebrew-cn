class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https:github.comsharkdphexyl"
  url "https:github.comsharkdphexylarchiverefstagsv0.15.0.tar.gz"
  sha256 "017ab7fe18caa3d13427fb13fd6050a9d8bf9aa26d1e1fe02924dfd7f86cd3cf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsharkdphexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a44a4b5ee249e86b36143290bbec04a32083ef81fa43567540c769dc6815a10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b91fa9babb7eb57011c2f3238efbabb1d969e889828dd90cbee76553887a0548"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d8c155d4810f8f56c72f75f815ffabdc5d9d4f8bcf39f27d8dc856df0fcbe78"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc12c9a965ad23a423263b9928e016749fc842e69938f09f1477e5f28388db2"
    sha256 cellar: :any_skip_relocation, ventura:       "29f47c94ac8862688184af7d2461eab6c3ec32040da86576b9390292ff0a0d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582a2dad400f4e342ab3f76f9c020c65117da35af0d3360d6306e2a32c853057"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "pandoc", "-s", "-f", "markdown", "-t", "man",
                     "dochexyl.1.md", "-o", "hexyl.1"
    man1.install "hexyl.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end