class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "7cfcca283100c306de14e2b0f0baec2be21568e93e00cd54850ac10af175bdf4"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dca989c14a7e48e3c5a901b78f8a1f33c21af30497bd902166e3147f20eab6e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4def6ae7dc8f4c9a7e7da210052640a31e2407a8fd04e31da0727ff9aa004da9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bfe994f8670ad3f844383c386a28f3f550292725aa588079fd75b82391b9765"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eafcf644f7c2ae67e805ef1109128c5248174f543d216b114c6810a832118c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119875bb4ba73535511414ee0752ca9f8be72126a2163f5dbf028d0d1b001540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ab74d265e4e4ad9e4fec69222f4df3c25fbcaec2d33cc7a3534509a980170f"
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