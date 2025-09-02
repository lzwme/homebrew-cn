class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://ghfast.top/https://github.com/gogf/gf/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "6fbaabc62a12095d70cff448e2f16dca483c91185687c27fc3b7f28b259a19e9"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5d3fe595aae6a5da019c2a3ef90970311a47e9944a6b2d5bbe304b300eb11f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5d3fe595aae6a5da019c2a3ef90970311a47e9944a6b2d5bbe304b300eb11f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5d3fe595aae6a5da019c2a3ef90970311a47e9944a6b2d5bbe304b300eb11f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9a1147d3fc155ee3e8175be1ec934f0e9b3b3727c62a6d5b23360b9e240f3e5"
    sha256 cellar: :any_skip_relocation, ventura:       "c9a1147d3fc155ee3e8175be1ec934f0e9b3b3727c62a6d5b23360b9e240f3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd7dfcee578961f553b775c7f102a02f4b552bc718a16721c3008c046217c560"
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