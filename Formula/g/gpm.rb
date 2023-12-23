class Gpm < Formula
  desc "Barebones dependency manager for Go"
  homepage "https:github.compotegpm"
  url "https:github.compotegpmarchiverefstagsv1.4.0.tar.gz"
  sha256 "2e213abbb1a12ecb895c3f02b74077d3440b7ae3221b4b524659c2ea9065b02a"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "02b1f03f80d4477e80aaa5b1cc62e9a4be9288f4d4116a23c386bb9b6fcd3906"
  end

  # https:tip.golang.orgdocgo1.22
  deprecate! date: "2023-12-21", because: "go get is no longer supported outside of a module"

  depends_on "go"

  def install
    system ".configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["GOPATH"] = testpath
    ENV["GO111MODULE"] = "auto"
    (testpath"Godeps").write("github.compotegpm-testing-package v6.1")
    system bin"gpm", "install"
    (testpath"go_code.go").write <<~EOS
      package main
      import ("fmt"; "github.compotegpm-testing-package")
      func main() { fmt.Print(gpm_testing_package.Version()) }
    EOS
    assert_equal "v6.1", shell_output("go run go_code.go")
  end
end