class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.72.tar.gz"
  sha256 "fed55ae86b958af95e41a9304e1e178a134dd4c0bfcfbc85c7f172859dd42bfa"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71cd2ca96d69fe8c499d50f679fb94927502c3cad268065066b9dc06659f3d4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f1d799fc43c00e72e033040eed17e597e40563061f501c873f98f7aaaf25689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ecc4978779470186129fbf59167593076930704e5c2cddf02e6d2bcdc54384a"
    sha256 cellar: :any_skip_relocation, sonoma:        "be77d671bd2c54a656fe73e55e0a5bfd2eca858cbdccf68ad4d513f7725394a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b698b5ab83a6585fc7c7e8c8913aaa76c579ff372dca71c5517b895d14756030"
    sha256 cellar: :any,                 x86_64_linux:  "1a7aec12e7971ff20d4175b2708a9574183815dba31cf27e86049e7a86a7d3da"
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