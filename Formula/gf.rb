class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://ghproxy.com/https://github.com/gogf/gf/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "6337f5187918c307d896a648787f0ebf2aecbc9d6c0aa94be43de15eb599f5ac"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc8ba6e617778f933df96ccc653b249b74b70b37854fc9f6a0accf6ce415d7cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf861a241dfd60afbb5cc8f05c05a380adb76496b423b06a09abfe1505a0d31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6d4ffc42dd40a5b8197285fb7b6a817d939c71aaf4afc2635c61c4c2c428dda"
    sha256 cellar: :any_skip_relocation, ventura:        "fd43dc9fa3e47be94856a6c7138bfea06643df07eb114e0cecf53b8936d372ec"
    sha256 cellar: :any_skip_relocation, monterey:       "91f9a57071e818e2399d038516b8144c7b3d2f250be883f84af7f3040f664431"
    sha256 cellar: :any_skip_relocation, big_sur:        "facded337495351022f3d8f740f068cfb236b1521359014119e375fdab39c5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a80c74989bcf86b38cee99ccdc7911f19d5fe9b217fb3e52bd95c15c551eae"
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