class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.46.tar.gz"
  sha256 "2b46c66817ad0782a42cfd376a7fda249e11bf942df7d3844a8c58d53eff5e53"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5211145028ab7b5d4af766eadc9436d15a713c3dd78c47aa27d0b0c7e9487352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36cfd029bf6ffcd7d5d8e0e02a793695b82ad414c9f08b6ba34eb2d1a1c63d09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f79766e61939ae48338148f861389b389a3011eb5dfe3a85400964717fd22f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "83056fc19adfa2e28c378f24d75656bf34b5eb14b11cd4a07d64b268ab96051a"
    sha256 cellar: :any_skip_relocation, ventura:       "0f9671d1e31d59e8ac42df9f888bb1c202ca408f3716164cd68f92832273509f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5034e48f7939bf38469513094bc2f1ba91b460b4bcb4c98edf10a412b3f57a7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}k8sgpt version")
  end
end