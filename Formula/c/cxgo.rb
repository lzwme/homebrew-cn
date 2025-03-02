class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https:github.comgotranspilecxgo"
  url "https:github.comgotranspilecxgoarchiverefstagsv0.5.0.tar.gz"
  sha256 "bbfe93f9e6351c5005af355dd13f58ab8bc81d810f2f112f0888fc647e0325df"
  license "MIT"
  head "https:github.comgotranspilecxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5dd98d1f2f7f29dd96eaa932cc87246ef7cf884e089ee615a56cdea66a4281f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5dd98d1f2f7f29dd96eaa932cc87246ef7cf884e089ee615a56cdea66a4281f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5dd98d1f2f7f29dd96eaa932cc87246ef7cf884e089ee615a56cdea66a4281f"
    sha256 cellar: :any_skip_relocation, sonoma:        "273da06ccf344c7c9c44216f2df4df5d09e1170b732e9e600a1a98d131938692"
    sha256 cellar: :any_skip_relocation, ventura:       "273da06ccf344c7c9c44216f2df4df5d09e1170b732e9e600a1a98d131938692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d9f75c1c1e3a3bec9a8c07cfe120208f804a6ae35ba92fe385f2edf492e67a"
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