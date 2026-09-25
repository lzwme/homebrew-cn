class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.62.tar.gz"
  sha256 "98986aeaf670f5f1ab8359fd34a800792328e1e71cb25284766ff93798260525"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77875fe811f2073d16d8fa66f1b7e0cf9309d4af991ef014b8e3d652815c9df4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5ed24703de91af4f23172ba9a3ac4287c86c2178dc9d4003599bddb07543cbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2eff5422665dbec5bdfd7ff88c8b0b20041a836ab3af8ad4bd04c17654138d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c0dad043d60221677bda341dcb3ecd3eccf057125f09dd559dd18fa6a0789e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "40e16a5b31e1cb27e58119bcd0d40897ece51016dfac5f162a35e14e083be7e6"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[-X github.com/refaktor/rye/runner.Version=#{version}]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end