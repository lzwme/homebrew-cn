class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://ghfast.top/https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.10.tar.gz"
  sha256 "a32f1b00ba808d906648e806f9d1e1102d4e7118230dbbd3ece5c7511b3ae84f"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b56ea2cff008a496f6d00b5a6c341781b58629e40b483f0e959f22bbb3b28964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b56ea2cff008a496f6d00b5a6c341781b58629e40b483f0e959f22bbb3b28964"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56ea2cff008a496f6d00b5a6c341781b58629e40b483f0e959f22bbb3b28964"
    sha256 cellar: :any_skip_relocation, sonoma:        "2222a870301afe85a2f9630b42aab9b6e8a54d7d6b833a10731001270628e9da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c43d72312a2cdbed0f8502855f1e4a4813bfec542e85fe7bab1cd2a1368fa29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c425b47c796e35e45621c9883c2512a9abfcbf9b77336a91a866addf400ec3"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

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