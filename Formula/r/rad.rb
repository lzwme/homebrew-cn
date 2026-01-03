class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://ghfast.top/https://github.com/amterp/rad/archive/refs/tags/v0.6.26.tar.gz"
  sha256 "058e21f24faea3a6e3ec8d52db0ef84574d6cac9476ea4e980aec91acd80271e"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0c321d8dc7aaa6837bed8f2119ca58dac89342cb9b417482b3b9406d8bbe60f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "284dc583cc944cfc5c28bf9e2b9fa29b8943830d52999ed7a86e180521f19ca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f351de9530339bb246832ba9d139066ccac8af387f3406b64e52cf922d93689"
    sha256 cellar: :any_skip_relocation, sonoma:        "099f633252729f3f80cd22356f5d5d66b05af1135d3d310c4ce106eec8c19d97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e54b222d08c541d9ff3b0b7e63a64b0b96eaeb4a60db17c45ab7c37b09248b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0af8a97214cabf6654789850eaa45ca6507b722dc4da5ef6117e70e77c51f6ca"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad --version")

    (testpath/"test").write <<~SHELL
      #!/usr/bin/env rad

      args:
          times int = 1

      for _ in range(times):
          print("Hello, Homebrew!")
    SHELL
    chmod "+x", testpath/"test"

    assert_match "Hello, Homebrew!\nHello, Homebrew!", shell_output("#{testpath}/test 2")
  end
end