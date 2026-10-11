class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.93.tar.gz"
  sha256 "aafd8278787ebf57d865be70073266849554ac9201bf770746b410db9ab6b1f7"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "166abb90610f164b301a2c870e17cc50ca0a1b61ab816add3a710c92e2d392fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30fa402c0fb23402fa754fbdba5ca5a3eee92b6e867f38e6c7bedf42d4479062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbc13eab23252d1c01972b2437bcc386da3a39075d6d4a62065598f56453c16e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c01b4657d282fced6be3e36bd26bdc3368e7acade14c937b27cb5d68cf701f4"
    sha256 cellar: :any,                 x86_64_linux:      "958584691baf4815988e9eabdf210b14276df1c444f5689ffb4436bc53a1b8d8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end