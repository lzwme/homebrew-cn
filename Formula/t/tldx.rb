class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://ghfast.top/https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "78cbbe9ee16ae9325443ad585cd9268015c36d804e108e70735e1424980277bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d06edd6cc26b04c283e7c78750901b34d66bcb7b44ef96449759bd572d92b1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d06edd6cc26b04c283e7c78750901b34d66bcb7b44ef96449759bd572d92b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d06edd6cc26b04c283e7c78750901b34d66bcb7b44ef96449759bd572d92b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a06fea77ec92a0d5fbe46e73480df1205b3b096212cc9bb48591b170e19dd5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59a3bb16acd52d8053416e93d843faa347b08a964c25f3dc4c686477c406657b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34839d6d28f0c43722f28875dd2eb6fc3225da3761959750dea8321293ee628"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/brandonyoungdev/tldx/cmd.Version=#{version}")
    generate_completions_from_executable(bin/"tldx", shell_parameter_format: :cobra)
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")

    assert_match version.to_s, shell_output("#{bin}/tldx --version")
  end
end