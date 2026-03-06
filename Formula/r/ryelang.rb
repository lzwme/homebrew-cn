class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "7882d757eacdf540f3c909e41c764f8dd786e765cc86423789d0c2d40d3b5335"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb3984a55a16ea5e8fa8410ed1e67ac77c4924995e0710d0f351a3f4547ceab6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fece8a8a9780b76e1b55700fc99d366a60204f4c55a0cfb51a6373e16c9a44b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e5efe69247f946dccaacbcbb0c5065de4beea48cc4c27f806168da0bfc54bd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "43da1975995bace52307fdfb720afbb07498c5887499d556dc27bbcaeb933004"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b32d99b6944d5ad9858365a831cacaf7a737aed7706f0fc3c8dc4d6324e763da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642d694ff3263e022d4fd811128626adf36db976033b65f6423579873e5bfdfb"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end