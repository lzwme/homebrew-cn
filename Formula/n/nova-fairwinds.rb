class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://ghfast.top/https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.6.tar.gz"
  sha256 "b97ee64a429667411e00e6075ca204bf1b65bca499f00b6b468cd5391383b630"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d4ff2b8735799119fa2ca51b8ad0ba69c44bad887edd61d1901834d23bd0111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d4ff2b8735799119fa2ca51b8ad0ba69c44bad887edd61d1901834d23bd0111"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d4ff2b8735799119fa2ca51b8ad0ba69c44bad887edd61d1901834d23bd0111"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e2d2fa125fadcdc32b5ef3d8d61b11b0b9a83422ab16e881f84b0dee184943"
    sha256 cellar: :any_skip_relocation, ventura:       "83e2d2fa125fadcdc32b5ef3d8d61b11b0b9a83422ab16e881f84b0dee184943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96de080d425d1caca170095ce428982cf2742f1f9d36b2b2a163e50bf01ab626"
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