class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "67f9e7727598ef81c6bb7ccb25a1f274d6cc773b1a0897dd6117b4e6db9fc92a"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdb0a33fde032c05d91673941c5483d5b2eca39b79b5d45919438757669103ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dafea8bad7c6d3cea20c5ff1a4be427d065809bb804585526e6235b2c0bc0319"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4fd6beff5d5c9cd4cd069ca072a69dd7c3cc8024e80206afdeeceb5252f7128"
    sha256 cellar: :any_skip_relocation, sonoma:        "61af22b2c1585f5ab5b95b41af4e20b2d5eed97f5a3eef884032a997d869948b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c68932b793de27e80e645b24290be26ba70cb5829b4719d4c57932d32529b71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f954b0d63df31e7aa1df802dccbe66d6047b5f9d45080130bbc6a238adcc140"
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

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end