class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https:github.comboyterscc"
  url "https:github.comboytersccarchiverefstagsv3.3.2.tar.gz"
  sha256 "2bbfed4cf34bbe50760217b479331cf256285335556a0597645b7250fb603388"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4beb1aae9804d3c3b35f9c48b5a3ba683238204589db9b82a3608b357d5cfe1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a89d5e71c171cae0c6f6b9c86a3b6c86551577c511a852c2650a0f48a39b70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2e3bf3b474504d8d66a6688d043e644441f9190e11f508b927446e95968539c"
    sha256 cellar: :any_skip_relocation, sonoma:         "165a9da34d571bbcdff077d8314a6beb331da483e973b0229a51750727792ea1"
    sha256 cellar: :any_skip_relocation, ventura:        "4a9702ac662622ad67f13c06e7f9ce2cf3a7d69ffd50c98d1a48c003f5dfdc6b"
    sha256 cellar: :any_skip_relocation, monterey:       "13cffa4e5825a259a6ec085637abac2085bdcf415043ababa8d90e79d069390b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba7d0417d1edd0c03bc469be6cd20d3dba910698a7f9c711a73a9440d4824807"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    expected_output = <<~EOS
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes,Files,ULOC
      C,4,4,0,0,0,50,1,0
    EOS

    assert_match expected_output, shell_output("#{bin}scc -fcsv test.c")
  end
end