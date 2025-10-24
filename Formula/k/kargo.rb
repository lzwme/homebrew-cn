class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "2af7ec397f00c8d4569ea672d1536a7fa5273fbdd2f3d71bf6e91e1aa1d9eb87"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70d880644da096e5538b978b265182d8287015b71ac0b53d7feb80c5be23cddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a399595d3524c57111273db461ed690ca93f98f39ff4b4f6b79437e7149c911d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eed8c7e874c69346b93384e00a29b050558bc1e4f8fa761946542daf6895ec06"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa556b673dddee6669bc541ac1860e64da1d365f9ab80378135a1822c8cfaaf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec7782c78eaf40fc0acbd8abdf1c3f5929f91bae0a5f2f6e0ee6609cd44a65d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f7d3aeb85aaf3437eaf25d22b0593e8e80dc9df9592f326cfd8b1a85925dc93"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end