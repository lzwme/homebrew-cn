class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https:github.comgotranspilecxgo"
  url "https:github.comgotranspilecxgoarchiverefstagsv0.4.2.tar.gz"
  sha256 "ac6fcf0573e6fd8060db248e8354b9877136f84547f3fc4af3ece85e03df1111"
  license "MIT"
  head "https:github.comgotranspilecxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b98556bfbd62b06a623e825d495a714c17679a71a179b7e6c4bd180303ab7e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b98556bfbd62b06a623e825d495a714c17679a71a179b7e6c4bd180303ab7e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b98556bfbd62b06a623e825d495a714c17679a71a179b7e6c4bd180303ab7e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e8587aa4932c76cb8d97dbbe6ec70074f522005a2803050aa30096337e89da4"
    sha256 cellar: :any_skip_relocation, ventura:       "7e8587aa4932c76cb8d97dbbe6ec70074f522005a2803050aa30096337e89da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b857eada57e6a2a1502c16e1d23faac1b6a82ed24d04eddfbb0b9e2e358f4eaf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdcxgo"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("Hello, World!");
        return 0;
      }
    C

    expected = <<~GO
      package main

      import (
      \t"github.comgotranspilecxgoruntimestdio"
      \t"os"
      )

      func main() {
      \tstdio.Printf("Hello, World!")
      \tos.Exit(0)
      }
    GO

    system bin"cxgo", "file", testpath"test.c"
    assert_equal expected, (testpath"test.go").read

    assert_match version.to_s, shell_output("#{bin}cxgo version")
  end
end