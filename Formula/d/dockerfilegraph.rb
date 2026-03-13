class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://ghfast.top/https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "5841ab981e1062f508198aa728a2dd5a63f0c8608d2894509a086f7206c1bafb"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41a6f66125b4968b3f277c8ebbe939e8a8b15472a6b246136302bee3ed6d399a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a6f66125b4968b3f277c8ebbe939e8a8b15472a6b246136302bee3ed6d399a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41a6f66125b4968b3f277c8ebbe939e8a8b15472a6b246136302bee3ed6d399a"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f33ceb147afe595ce93bb38c3cefa254113f5827d0bdbb2145a88eb9594476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "388ada6c3f5a6a2c5d2673c8d77d4917ee508fc85d32cc97eccc6fb2f085c3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0280b441c10a2326e7097f0fcfcbe39a9c1cf801c08856b26c4baab99e5743"
  end

  depends_on "go" => :build
  depends_on "graphviz"

  def install
    ldflags = %W[
      -s -w
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.gitVersion=#{version}
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.gitCommit=#{tap.user}
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dockerfilegraph", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfilegraph --version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine AS base
      RUN echo "Hello, World!" > /hello.txt

      FROM base AS final
      COPY --from=base /hello.txt /hello.txt
    DOCKERFILE

    output = shell_output("#{bin}/dockerfilegraph --filename Dockerfile")
    assert_match "Successfully created Dockerfile.pdf", output
    assert_path_exists testpath/"Dockerfile.pdf"
  end
end