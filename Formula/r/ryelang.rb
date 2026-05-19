class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "59e9cf98ba9335691bda8d2eea5d1133e1ceb7c960b8de7c9e8cf64108663e03"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc478a9c3191fa93d577b26e3e0a7c5ede1d9b1184891127d1e96d6e9460db3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa87ab56e928dcf49b4cf9be4af39b6f838f6135cfa7cef1702b0c6787feba68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec54cea9631a9857b6b24d5fce3214658d76c51b718582beec71e9efc99048d"
    sha256 cellar: :any_skip_relocation, sonoma:        "12ce7fe1e0aa058fa00d16dc885473f309f203bf9ad44c43cb10ba423828be87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4083ed799fff9e95711ff51318009c7e8376a4fc90b8eccd5eeaa0e838b813e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9221df7cb765529b4fdb2e930e5db8a7f4fcd350c5eaf5c1837fde41507fd5e2"
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