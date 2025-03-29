class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.55.tar.gz"
  sha256 "1de07f9378debf7f1b11c60c424d72af06c461472ae52b03ca820584f7a72b88"
  license "BSD-3-Clause"
  head "https:github.comrefaktorrye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff58b3dba64bdcfaa00f753fbd25ddcebb1846b38b1be9c3d0b631399ca2feaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8bc677da8e85a6d234270d164811b0a3b51549b5e71e14acca0460d6f351ccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6957ebee010bd7d79ea1651124c5b5c15ff6778a82b59304791a662906122329"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bb50988bc7d0cd3cab7286e4ff6e1e341d59f5111541536e5b81793e142ce14"
    sha256 cellar: :any_skip_relocation, ventura:       "02cca9e77375375287348d310a96a9f3b8da54576ce85dee3390d0c302181a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f8a39789e9df6e10c39e1e800b878287f49805872549a49bc71895701ba751"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    (testpath"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath"hello.rye"
    output = shell_output("#{bin}rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end