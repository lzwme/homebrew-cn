class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://ghfast.top/https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "6a8881599851c683401679ec597be7ee235dc3b21521d03d278980bc5811fca7"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d6852c74935a3d61c79c1ce63b3a919cfa2fb181cdd474f834e72519bca9e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48d6852c74935a3d61c79c1ce63b3a919cfa2fb181cdd474f834e72519bca9e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48d6852c74935a3d61c79c1ce63b3a919cfa2fb181cdd474f834e72519bca9e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a6e92715c77b60e8fbdd69ee0add71ca95d9154d556a8ad01f510877b9637bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c23b7e6e6a3e01b50821476d74b1e90d2b33746f0e6a7d552b4aa1f778d35cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db8233d192bcabcad8519d9b59cba5e565123754af7797c737078aa93fea2ccc"
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