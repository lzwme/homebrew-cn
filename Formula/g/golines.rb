class Golines < Formula
  desc "Golang formatter that fixes long lines"
  homepage "https:github.comsegmentiogolines"
  url "https:github.comsegmentiogolinesarchiverefstagsv0.12.1.tar.gz"
  sha256 "7d5a6959385c64e6edb30188f05908ed7df09b9c2ff641f49fcccf98c1dc8037"
  license "MIT"
  head "https:github.comsegmentiogolines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec036b8ab6ed8f1f39cee60b0fa012df9b3416acb1499e5e104d3fefd5fdd82d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7534b2ba6c487a8a9b722ed26c1b6f943653f20d73325aaac840ba5d4e15086"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27ede416e063116454cf62070a5ed8c0d72751543511e45645125ec5e31f2cf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd4610d13bb6c2f681b8ee0b95bb3d2f5b960cbc1a998f7e885f9c96743ce23c"
    sha256 cellar: :any_skip_relocation, ventura:        "8d57a962365623068f6786643d98c11e8dd29d3000c74b93aa4449b1c1cef889"
    sha256 cellar: :any_skip_relocation, monterey:       "489ccaf9f5c24bdde5d64da0f625d3e01f829fd9dac5471642958d0a5f6e8899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b63594f70df0edb01073a18af99ef045b5442d7fc5289e5541afb5b8e9d1f38"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"given.go").write <<~EOS
      package main

      var strings = []string{"foo", "bar", "baz"}
    EOS
    (testpath"expected.go").write <<~EOS
      package main

      var strings = []string{\n\t"foo",\n\t"bar",\n\t"baz",\n}
    EOS
    assert_equal shell_output("#{bin}golines --max-len=30 given.go"), (testpath"expected.go").read
  end
end