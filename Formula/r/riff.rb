class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags2.29.1.tar.gz"
  sha256 "e993a7e513fe752d77a1328616b858b2f7f94a0212356e815ebdf9c16305b902"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88f8317f4cb3e90c0da3673e83b04d8c4d7ff447983dfd99b2359812d6054bcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab4f2b1e89bc347a0ddbfe44eb36f736815c9580cebf05c18c6b30c729ded1ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0260b4467363132b5194c90f0e37e94ff62baec3db9d9e517ebfe13d0ea9382"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaf2eafcf15eb0190cfe48b2ba76a6eaeac755422e03ad747098b3432f79a954"
    sha256 cellar: :any_skip_relocation, ventura:        "8d2cd1371cbd10273e96005c0318bb4ee4dcd014caab9b7f4785cc45d5ca3638"
    sha256 cellar: :any_skip_relocation, monterey:       "94791fb05d446a2147a8fbb21f70dc289221928983c5dde87b63c0d598aa2037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29a58a64f1519be715fff3eec60585f268abf62fdca34bd8cb5758cb6559cb81"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end