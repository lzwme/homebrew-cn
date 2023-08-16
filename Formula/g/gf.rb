class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://ghproxy.com/https://github.com/gogf/gf/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "a15942d9d2d644a4cb9f8982a54c3ee58cb7830db14fa2c3f661164e931c8931"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13e8206c1c67974d00e9c98ef7c43b36c4077d7d46eb5038e54f4c1722ccb990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0da836294f46b8ae7c2e19fc9d7815eeb39347fa48766abedc8e29fabeb2cf90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c7f06021c00530b6923682eb014081df33a4c2eb198104d4d3a3779b0a50770"
    sha256 cellar: :any_skip_relocation, ventura:        "a007d763cc4c893a2171ded871b80973dbde9a944472c75d9c5032a780d8e1c6"
    sha256 cellar: :any_skip_relocation, monterey:       "1c2855a8b090f889fe8cce5f521cb03c542f7e588ac69b225c3bea874113e052"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bca6a0521be465a237950a2f9657e58fd21e1a3124df2e6945b683c13c5ef95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a20b417ec518742314be6afd4104fd86e5c757dc6794d87f800faf7ab90886b"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end