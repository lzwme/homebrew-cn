class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://ghproxy.com/https://github.com/terramate-io/terramate/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "e5df311ea9aa5897541042e51ac37c97c202401dd2a0a09e8cd4f5c07c583387"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09845be967c7c7772c2691d31804b2667d919608437d25ed8f317c36cfd523de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e505cb1076a90f3c6dabb2874ee0ac78f9b0215567ff12b1a993507a5d17f1fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8539a97c90816bcdb8608a84bf1ba47a71bacadb5effc68051bf81438cc77d7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bdbdaa2e535441442431f6f629141166a21ebc3dbfbadbc182d4549fc598e95"
    sha256 cellar: :any_skip_relocation, ventura:        "91cafffc306e9431c78eec3e90cd7138994ecac59cd0149d3deec722a45fc470"
    sha256 cellar: :any_skip_relocation, monterey:       "1710427970bd7edd4ea3d6d5ba26a2199533a279a2826e3a634c5b5ccd51db04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79c90941cf48b378be20ca4db95c9fb79d9af30a44aeb8ecec830b3bf6a28361"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "Project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end