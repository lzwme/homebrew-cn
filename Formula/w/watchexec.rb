class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https:watchexec.github.io"
  url "https:github.comwatchexecwatchexecarchiverefstagsv2.0.0.tar.gz"
  sha256 "a613143f9cc8a1ec2a917ae2dd0c03156bf79e6a2dc1ee1ae76419ed47bc8d29"
  license "Apache-2.0"
  head "https:github.comwatchexecwatchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:cli[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6cef24e0b7deff3df241c75f906d5c8d86afcb464fe4b65fdf22a7e40aca9f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac533de3a46abd21f93bfd5832678021dd0b17d20b0eada4fb8c0767099f7808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "533826fe0f1a28e44aa7c939f908e03c479b7efbd0d38240882050fc037efaf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe880b575ca38ba112d24bd1b659d903235fcef61f93870515cc3530b9192b5f"
    sha256 cellar: :any_skip_relocation, ventura:        "7e961399e53c1f5914da1915c5100902ccf6588e9d053efa921cbfc8297d013e"
    sha256 cellar: :any_skip_relocation, monterey:       "d64e3541b2fd54e9e39cb7d4726d071b70d901f07df3b8e683eed1aece5576e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73956f9d8cb8cb2abca511906d681ef44a621f3febba3341cc55942ab228ca74"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"watchexec", "--completions")
    man1.install "docwatchexec.1"
  end

  test do
    o = IO.popen("#{bin}watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}watchexec --version")
  end
end