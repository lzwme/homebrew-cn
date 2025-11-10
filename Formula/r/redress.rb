class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.46.tar.gz"
  sha256 "fe98497cd5a976c1ff6b4ec9b999a2dece34d664aef28714707e805d287e00d4"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3217ba77e5b86667182e226f22b5d92bc8d727102dc01b0bbe5fd4cc97c61633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b82e1e0d2c99ae1e2f0ca69a28e3aa6007cef52a73b621d50387bfd1b561295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91716a7cf7b2c68d36b31d5bb265554abf6429592c7732cb31bf262ddebb8404"
    sha256 cellar: :any_skip_relocation, sonoma:        "95224a48ee85301575687cd1f04fad7b0708c917e5c28c6954bc5de11df9e08c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233b648860652e65e11f8cbe2e45d45c834ba8780d1ab09f134b87add0f4c30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4829260cc22c1c8c9a3cc56caaa39bea666355b44064e57ebe6491fb1d90c949"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end