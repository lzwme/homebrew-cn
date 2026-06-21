class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.76.tar.gz"
  sha256 "dd02fad350bfac9d19ab90b88f85a56d6ec633eb49cc0b3adc2be7a077a86c39"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0363dc888698d74d81bc0dc115cf69283773bf053673c26cddbf6ed06266714a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "766fba1382d6631bbe8694f6419c72a18b633776b013d3c2452a3cce4b2a556c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7abafdc1c3f927ea20952f6fb77f505babaafcafac5be089e2d0f1df097d23c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e08ac4a0c7fd13b628b7f621ba788c6cd64691d6c585dfd39c6435006b91032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff1e171e401fde75cf7d6db84ebc5496c26564850bf37d53f8869db0f96efe70"
    sha256 cellar: :any,                 x86_64_linux:  "6d8782c92c13970720aed42b8e7ca7126742c7220777317aec7f96f0ab5bd390"
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

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end