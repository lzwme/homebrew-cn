class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https:github.comgotranspilecxgo"
  url "https:github.comgotranspilecxgoarchiverefstagsv0.4.3.tar.gz"
  sha256 "231230723572d49bc74b9d58c9f15700cbd3b9287d6e281b8d53cb580ad58d3e"
  license "MIT"
  head "https:github.comgotranspilecxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e46f296a649e4f4f524de427e79cf5a8c28ac4d5b55f3e5aae9243b7ea31f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e46f296a649e4f4f524de427e79cf5a8c28ac4d5b55f3e5aae9243b7ea31f31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e46f296a649e4f4f524de427e79cf5a8c28ac4d5b55f3e5aae9243b7ea31f31"
    sha256 cellar: :any_skip_relocation, sonoma:        "52cc457a3e45486011265da5f3c5b9f702cfa593fc943d23c4606d2708406b91"
    sha256 cellar: :any_skip_relocation, ventura:       "52cc457a3e45486011265da5f3c5b9f702cfa593fc943d23c4606d2708406b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42180c97c67c678111bed63bd39aae1663b8527e8adade1bffffdc048a676ead"
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