class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.64.tar.gz"
  sha256 "56978ace26398ff7c80efa33e11f757598a9c6c45613e782671e292cd55ce77f"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc90744628f70554182b7b0d2e4c980538e38a7264554b78c46e930dd89d246a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52db176df5c1fc83cba7006efe906ed6720f59f28413a3e3708813b1354495af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "451d4d4306a4aa9143657a1d6e94464318d85879462aad12fa54d325cbbebbc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2637615ffa7c9e0b443e12811df3013cc7a561217d05c14de7087759e3de6227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9a6e35c1fe04919fe10b93e2eb7772dc60ffecf68ba9b150b9bc94d133b845da"
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