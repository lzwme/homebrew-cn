class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https:github.comms-jpqsad"
  url "https:github.comms-jpqsadarchiverefstagsv0.4.23.tar.gz"
  sha256 "bdb366b6c3a3cb069d4d4acb33faeff6f6c40d38ed4bbf66fafbe46e71cbafda"
  license "MIT"
  head "https:github.comms-jpqsad.git", branch: "senpai"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdfdadb1427daffaa162ec8e3d3bb59e5800bcea3f9a6752c889777d58a2a5d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11cc4875f8a0e61f5460c32b690b3383a05977c1781757eb5fb2d4f1f0af551f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1baefaec3e780a624158013dc5f43363402d814f285cf6b6695acf1865b9af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1604ed184a03f92bf1fa7d8305b8160b3976b5e4a3239efdde084b595d880ae1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e88274e8bcd5288ba6180b48bbc43ddf1e9a11654be75b472f4150dd94f632e4"
    sha256 cellar: :any_skip_relocation, ventura:        "2fdbada4bd1ff10afcb0701481ab11f939a166c1cec125af80e7b383dbcb442b"
    sha256 cellar: :any_skip_relocation, monterey:       "db6d9b36c126b985c3e2346b5ce8a6df779e80ee9ce2b8deff4517e5bc0820ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bf2d0ff89c1ea56cec9e067628d57b00be4b143a437bc2cce47d9e8933e01bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2115afbd70c36285540df21c3de43d145570f9cd032ec664d970b609e81efc35"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath"test.txt"
    test_file.write "a,b,c,d,e\n1,2,3,4,5\n"
    system "find #{testpath} -name 'test.txt' | #{bin}sad -k 'a' 'test' > devnull"
    assert_equal "test,b,c,d,e\n1,2,3,4,5\n", test_file.read

    assert_match "sad #{version}", shell_output("#{bin}sad --version")
  end
end