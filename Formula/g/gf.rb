class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://ghfast.top/https://github.com/gogf/gf/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "2570104af62490040c9abe00098f7dd896207ac008b28b23dce6c0b4b932286c"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d891747198c587f7debb910d26dd27dc322a22977afa726f799bf679ca362093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d891747198c587f7debb910d26dd27dc322a22977afa726f799bf679ca362093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d891747198c587f7debb910d26dd27dc322a22977afa726f799bf679ca362093"
    sha256 cellar: :any_skip_relocation, sonoma:        "a19149622bbe926da3308db7237fb76e1ef587eecc44bf7465d44c83cc8abac0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f748da0bf9632bfe83080a9a8793f0c88cab55eceb8a033d5bc62affccac10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b168ad692dba03d1160570e477c94675c572578da029640ba9ad80e4ea24fab3"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end