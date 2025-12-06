class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.0.90.tar.gz"
  sha256 "60a3a59458f1e338c6750431ac189ccac02c8d210c3f9bf07b56c5600eb59b72"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d1a40e97d70ab1f04f6611c91c646c99d4cfae38488da079b6209cbf6213db3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c87936ab8c2af7bda096c2463670814b3e0988900941b7a47f5d969ca37e9753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd00585ff72bd62859c02004f446e9eac3492052ac80dc9343c6b87333a409f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbe3d64a2dbaa782c1d345a137d8921c573cf620bcdb5281f9169edf003b6d84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14a004d6272c71a4cd650dbc2b9ec4cbd774183991d54858c7009bb2323fb490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b72dbe77b7601f623da9fcd1fe3a12c239661d918138ce081a70cc1c2746d0"
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
    assert_equal "Hello Mars\n42", output.strip
  end
end