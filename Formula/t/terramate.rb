class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://ghfast.top/https://github.com/terramate-io/terramate/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "2637f951f6604c2ce43bc13754d399fa17f8f6cc35f602ee67cd88ab3ea7a6b4"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e5151f1234e2d54841dd88f477e81bca9bb18997f64615c42abe9dac2cb0745"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e5151f1234e2d54841dd88f477e81bca9bb18997f64615c42abe9dac2cb0745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e5151f1234e2d54841dd88f477e81bca9bb18997f64615c42abe9dac2cb0745"
    sha256 cellar: :any_skip_relocation, sonoma:        "765186e469adaea985eb0dfc86793bdcd425a990bde29b828afeb85ae50a4c87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fcd4665336360a711f3af213b67f7e080d57fd59a7ded7989ecb9dff312df6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "937ed62d168c24e5ae4e46e9642c3bf44d80cdfa2460d62aac989c090a9221cb"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end