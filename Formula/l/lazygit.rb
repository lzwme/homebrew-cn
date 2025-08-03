class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghfast.top/https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "3df7680f0d5bf58fc9912ca57362fc544ffec05d40b54d4163031bc005abdb8e"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18ea7887ec9373dc91c6a17e27d72d5071ead67874259edbf6ba8518310bd8e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18ea7887ec9373dc91c6a17e27d72d5071ead67874259edbf6ba8518310bd8e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18ea7887ec9373dc91c6a17e27d72d5071ead67874259edbf6ba8518310bd8e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba8ab2a1df02f9e76fbd93bcd4d944aa21de8e27ab5fd85c2134b6efc297cd35"
    sha256 cellar: :any_skip_relocation, ventura:       "ba8ab2a1df02f9e76fbd93bcd4d944aa21de8e27ab5fd85c2134b6efc297cd35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdf0b60016fa36b6c5f75db638291fb91e1d53033a6f27883809849888214a0e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end