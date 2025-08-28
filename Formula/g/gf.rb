class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://ghfast.top/https://github.com/gogf/gf/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "08006c604d9bc8d1face3ce8919cb688c2787133eeff31da06ed2d31226cdf98"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "912dd47d1d2daec77b4a02d9f4ce1af7f18d688655852092d8c8487751192736"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "912dd47d1d2daec77b4a02d9f4ce1af7f18d688655852092d8c8487751192736"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "912dd47d1d2daec77b4a02d9f4ce1af7f18d688655852092d8c8487751192736"
    sha256 cellar: :any_skip_relocation, sonoma:        "88c911cb3b5e9bc5e25d796038570537384667813b97a85bc55d6e255f84982a"
    sha256 cellar: :any_skip_relocation, ventura:       "88c911cb3b5e9bc5e25d796038570537384667813b97a85bc55d6e255f84982a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab64d92bd23a37f579283e480c28706d41217a8f30d7c8ede49d77853a523a0"
  end

  # Use "go" when https://github.com/gogf/gf/pull/4313 is released (in v2.9.1 release?):
  depends_on "go@1.24" => [:build, :test]

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