class Clangql < Formula
  desc "Run a SQL like language to perform queries on CC++ files"
  homepage "https:github.comAmrDeveloperClangQL"
  url "https:github.comAmrDeveloperClangQLarchiverefstags0.8.0.tar.gz"
  sha256 "67c318d5299af809abbd3ddb5488d10be6c71710169da79292523a0d48ef0042"
  license "MIT"
  head "https:github.comAmrDeveloperClangQL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ada3f50576f33babd4d8f892ea28815d0cf5f3e3ffd5ed0d18f3babf403099fe"
    sha256 cellar: :any,                 arm64_sonoma:  "dba23c008a80c8630ccad588e58742b549d505a7928f4fec291236ff35ffd3a6"
    sha256 cellar: :any,                 arm64_ventura: "819e5cfb701b282f6bd932563337d182798a8773142118f4960ecad6b38d36ef"
    sha256 cellar: :any,                 sonoma:        "f9bf658f80d0e81fd832409830b581a2f7b139d4db133449d4bf22efbdfdca1b"
    sha256 cellar: :any,                 ventura:       "622cedd6087bb9f3059b66134c16dc68883ff17cdc6d6b70688230f57137b086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "734936caa6e862354ef13d18839c9489d2710a02416d1c02ec668a32a932dbfb"
  end

  depends_on "rust" => :build
  depends_on "llvm"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"test.c").write <<~C
      int main()
      {
          return 0;
      }
    C

    output = JSON.parse(shell_output("#{bin}clangql -f test.c -q 'SELECT name FROM functions' -o json"))
    assert_equal "main", output.first["name"]
  end
end