class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://ghfast.top/https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.22.tar.gz"
  sha256 "091bf20e8ff2e30926c27d98605ce3a9d019065edfc1601b62ffab9361d6f1ec"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "478bc498aa8562961c46533d2a1807ae5a4caa10583f9928dec24b76de0b2195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64e32e1b624705c3289982eb320b5a670d6f69e9239d0e34b8f8a37fdb2a3016"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f279458d80a9343b18eb7f6f350fefff1fd452a60bba04e39538399004e2d82"
    sha256 cellar: :any_skip_relocation, sonoma:        "d95f088c91cc8605172e8451c7f5fc100b3f4663dead9965ab5a7e282b99f2aa"
    sha256 cellar: :any_skip_relocation, ventura:       "1398bf606a4e32da2b736fba0e0a051a07bfd9aaf22ae16ab9741160415250be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4fd5fffe5adbaee8176cd6f128c13a2effa3245373c3a66722a935f9376025f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18309879ac1b775ade93af83416dc08b3209ced35d29cc4aa9cd9cb6f1cef812"
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