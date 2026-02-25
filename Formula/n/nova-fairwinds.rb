class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://ghfast.top/https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.11.tar.gz"
  sha256 "d238a9e3f5a872b472295253c5c2d62f8f7a29786f1e67436bddf086ef90e42b"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88f5d41ada41956bef24e1159c07ea45616dc0b5ce610c81962f2129fc985237"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88f5d41ada41956bef24e1159c07ea45616dc0b5ce610c81962f2129fc985237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88f5d41ada41956bef24e1159c07ea45616dc0b5ce610c81962f2129fc985237"
    sha256 cellar: :any_skip_relocation, sonoma:        "1135c8692cada34603d8f9c6682ead80b44de167a6a62a605d262df6e2200e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79c6a88677c10c86882fd451f3b1ed9723cd312e13ab7cfd8d414ac33b931117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1908a0616d6b9b8fe109d2e0b77f68d1e4b7a43533cde1996a4bbe4b974237b1"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end