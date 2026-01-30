class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.1.00.tar.gz"
  sha256 "3102fb87b74df6912dee4efea785ab3e0e70270d1d5e2cfece813fdc0b1ff24d"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a7ff363ef48c53675d9f4d60e4d4a9e7e354cad0b28a728094d11c0fb60f559"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ba56c8b8cd138156c3ca46f559a9fdd86ea6895614e8fcedb28437b2f618f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "060f604e5a49c3184c29c588fd2274e996aa7414b721fb1ca686fbe7ccafe2fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d3787cb895d51db1213a3e43361bb3ada6a6e6b4cc1348a2ad07ea5aeb7d7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b9a591a10dd1fd111dbeecda722233e2c5f23cf65d592e5c7ccba27230ee5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba69b8d3b5b64b2d600b442d7ba26ebb18a62ef223c9880da9d7e18b4191562d"
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