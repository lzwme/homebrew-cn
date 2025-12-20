class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://ghfast.top/https://github.com/go-delve/delve/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "80c69d5bbfd80350fdf2022395877c013d14397f099c729b9f44b94d62d127ea"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc53d895c66bc8b0b0cab4c6d3a0553824916b03ffceb98cdaec7b0800f1cef6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc53d895c66bc8b0b0cab4c6d3a0553824916b03ffceb98cdaec7b0800f1cef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc53d895c66bc8b0b0cab4c6d3a0553824916b03ffceb98cdaec7b0800f1cef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b33580d3d374f88e5127e01691cc9849d350124b127c8c2efd6c768881d991a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86c74235355e1d17ca3f5c4c8a8690c7a8a33aa40723d1183107acd94f641246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cfdaf3ff6e7c014e645b1a4fbcdcce1eba89fb0b451082d2440d4fcbeb983a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", "completion")
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end