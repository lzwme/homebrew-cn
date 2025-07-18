class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://ghfast.top/https://github.com/OJ/gobuster/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "480e54b0d02a6c09c702c6df07430fc4e9a458d54485568c66e6e8bce3d3d748"
  license "Apache-2.0"
  head "https://github.com/OJ/gobuster.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bb616f59600d89af8bd6aa83258e49e6c9bfc1240ed91dd20029f596359ca3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bb616f59600d89af8bd6aa83258e49e6c9bfc1240ed91dd20029f596359ca3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bb616f59600d89af8bd6aa83258e49e6c9bfc1240ed91dd20029f596359ca3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "564fcfdadce3a9c6df66619949c42bfaa65e2da087fa86367ddbbbb63030c77c"
    sha256 cellar: :any_skip_relocation, ventura:       "564fcfdadce3a9c6df66619949c42bfaa65e2da087fa86367ddbbbb63030c77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c384fe0312f2d4feef2f31d4bcae1ef8a86a1a527bf7e910214e170834ea9c15"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output

    assert_match version.major_minor.to_s, shell_output(bin/"gobuster --version")
  end
end