class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.65.tar.gz"
  sha256 "f3c27c35426e69ac7cf26780502ea90991eb0b7525dfb68c462a321d498aced9"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36e1c5b999579279f77bc582fa12e71f8bd2e4c5b218410b4e2c2a92a575fe5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0589e1d32176499de3c1e31380eab4a5b7c11d5b9f0e6ae179ccd480495711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4c5b446a584f5f11d92f483b3b9f938c69378d7583755c3fda9f32f6c14833c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5303170ec21360fe1d11dc8d0fca0bddef15c9e69e88f2cf1ae4a2597887c395"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccbaa4e58ad6782ea437172ba7c4cbe7aa7274d0cda2ece15d8e3fccadc4b110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29ef016746fec6abaffdf06213c962eb5bf73f816f8d1c88588dd7f56c9b52e0"
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