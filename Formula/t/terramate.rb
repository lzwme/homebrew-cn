class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://ghfast.top/https://github.com/terramate-io/terramate/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "68046a13aa24eb808c39d34eed86b6437c50a9ed96a06cd08799524345279423"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c885d4b9dfe7647e0f8a6b43d21f3a5ebb72ac3e12c39e32afb79b8d03db0ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c885d4b9dfe7647e0f8a6b43d21f3a5ebb72ac3e12c39e32afb79b8d03db0ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c885d4b9dfe7647e0f8a6b43d21f3a5ebb72ac3e12c39e32afb79b8d03db0ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee8a111fd07efd5eaac0fe55ce82aeb643b3c7caacd1a7427f5516241bb8e901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b0fa308840c3f3f543eddf770e758fba05b43148c92ba09f809041da6a28357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75bc5e01d38ed641904c12866194cc592e2d7eabc7395977ed2c22d527fb7cd1"
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