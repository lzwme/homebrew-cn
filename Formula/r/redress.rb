class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.31.tar.gz"
  sha256 "1a71756e87e875b477e261058458c187ce7e541daa583451b48d9c4cc330bbe4"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fdedb6be4f0b1e99f84a922a6bcae7182f4ab5863f26ca23c8de4447091e4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fdedb6be4f0b1e99f84a922a6bcae7182f4ab5863f26ca23c8de4447091e4d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fdedb6be4f0b1e99f84a922a6bcae7182f4ab5863f26ca23c8de4447091e4d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "adfc502b5e453e5af86e03b8a10214c31187b936964bc510e61dd7ddb2e47d17"
    sha256 cellar: :any_skip_relocation, ventura:       "adfc502b5e453e5af86e03b8a10214c31187b936964bc510e61dd7ddb2e47d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3446702e1dc99dd2462cec389379abe25fcb7b589f42b078b86a1e68d0bc5dea"
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