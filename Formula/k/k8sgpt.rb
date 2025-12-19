class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://ghfast.top/https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.27.tar.gz"
  sha256 "e06254767dcef13a16f8b3ebda3cd9d3838977e1d12064c78114bfa741482f25"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2474d981a4f3e9e1a850b67f10be4c372c2b21127ccec1142c527a18b960bf94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c3ddbf3a8983c96e1bf3d63f92e18078ae50a4210bc2df4ed1cfb80dcc93e4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5149538162878038dea7277a499d7a8daa0497944687f8187e2be134ae8e1b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f68240766af0c12512a6c5a1b8522e23fe7fa67a8202887207915c010ed08a35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a77ff21d6536b22f24b91247abef242fd1b39659d5543054923024f4b45a7a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c12d783f64d2920782b9c0562ba1a18ba24ec1ac47e875bf2761952919c7292d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k8sgpt", "completion")
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end