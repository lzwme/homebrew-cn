class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://ghfast.top/https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.7.tar.gz"
  sha256 "3564d90244c8f7790d7a02b52b61a7b4ba7dabcbc6886d156d780fff497d00e3"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52dc1850073c9cf0b7d0df2c3072b4dcca7609f600da0b22fabd6296299b8052"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52dc1850073c9cf0b7d0df2c3072b4dcca7609f600da0b22fabd6296299b8052"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52dc1850073c9cf0b7d0df2c3072b4dcca7609f600da0b22fabd6296299b8052"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad8ba55c5c677aaf0db53b12016b74f66d029384a38f20b2f1920c670990a12"
    sha256 cellar: :any_skip_relocation, ventura:       "cad8ba55c5c677aaf0db53b12016b74f66d029384a38f20b2f1920c670990a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "328d1ae14ca7cf4c0b5b1051b058010394e0d7c18c663985d6a709eb79a6ea10"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end