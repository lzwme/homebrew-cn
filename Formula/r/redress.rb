class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.33.tar.gz"
  sha256 "45f7e0dae2ad00cbb703516fe3b74ecc31f9e0cc648887d5924c379a8ef8433e"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e38c521204cc9c659d8ca0166172186de7d1b7f0e674b3bfda67ade8aa17a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e38c521204cc9c659d8ca0166172186de7d1b7f0e674b3bfda67ade8aa17a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84e38c521204cc9c659d8ca0166172186de7d1b7f0e674b3bfda67ade8aa17a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d58f66525a225bfbed55e796d883ff1086973c5c901a93956c029c25532837f"
    sha256 cellar: :any_skip_relocation, ventura:       "1d58f66525a225bfbed55e796d883ff1086973c5c901a93956c029c25532837f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f62456ebfde984519300e9dbbe84155eff5cffd2934115b572a1ec009eb5d8"
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