class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "6338acdd363614d3327e8b4826492b98133748997b43016354a45fa55e799eca"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf55b88dd0e9576ce68596d5060abd376bfd72e662edc0b5adbebcccb8734b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf55b88dd0e9576ce68596d5060abd376bfd72e662edc0b5adbebcccb8734b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf55b88dd0e9576ce68596d5060abd376bfd72e662edc0b5adbebcccb8734b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "f96ad2253590a895ef6ead0835d035e0bb436765a54e12e2ca1cb51dd04fb968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5aa32bdb1457b5f78a1a880bbf73b8b78960322fd4ac3490a6353b1d1f46359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3068598d2c124e96827f8cf3faf26afbeac665087f0452b9404ada75316be582"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end