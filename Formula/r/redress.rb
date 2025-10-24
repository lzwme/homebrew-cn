class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.42.tar.gz"
  sha256 "58c1a984aa987fbc445490817bd89d36aa980ddd4f7bf1a926d5bca80740ca5b"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfc83ea9a0033468e1369101f88ccfe0350f72522b78e462b254895216a398e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc83ea9a0033468e1369101f88ccfe0350f72522b78e462b254895216a398e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfc83ea9a0033468e1369101f88ccfe0350f72522b78e462b254895216a398e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed3374709d0e922fb8278f1e2085db982d85a54b8382ed401fb1ab92dbbe87ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "142e1bf0deb847a96c013c156bee11b5a36a7049b8c6857199a24dd7392c0ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfdac5db64c5fba72c47cb029e0988ef90b2dc827b492a51f8d57ffc28dc95a1"
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

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end