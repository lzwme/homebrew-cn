class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://ghproxy.com/https://github.com/gogf/gf/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "00ecee44560ffe5fc8b9e5367f760b431b65fbc91c7a690849db43d79c9da67a"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4082b238eb80b5b657761981a08bfcfd6db2037462de9bf79f3cb6dbd2893a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6edc3335ec3d3132b32d174e33fd5604edcc2d7ef7ef92322ff4a1f8307bcd98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad011eeeb210826ac3eed475cd2abbdb2f8b4a267a656c0e453b58c49f24833"
    sha256 cellar: :any_skip_relocation, ventura:        "2cfe17d7725f352358b8be65194b889573452e123450c27bf25f7c2539de8abb"
    sha256 cellar: :any_skip_relocation, monterey:       "07bb152bc4875bae2649d9a017881197b3ca253c23caf7ecb31b2551d772aa58"
    sha256 cellar: :any_skip_relocation, big_sur:        "42c0bd8088e59c14b3bc91d2397a4993c4c9be9476b9b972bf5d467c90a23176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "192faa4d3143d8f696420d6d77b1a99066fd4902824a2ced4aaef19c8b367c45"
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