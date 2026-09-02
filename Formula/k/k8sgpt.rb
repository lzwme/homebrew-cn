class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://ghfast.top/https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.38.tar.gz"
  sha256 "fc31d4755f7174e3935baa3ae2867e25c78d32c70f5951de61d346ae72ba2747"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "625e06380b2ebb42ddcd198d5631961dcccc47f5737668f8062f0a52f8052abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8e4a5bf515b26d846f05358afe2ac05a86de625f7dc1b1de6b4cbe62254f3a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d2b6d3320a581af6fb8d214a9cc0113a76d6d80158404e8e19710cda4a76391"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a601c71544157251f9287299c482053592b4fb2a4c5e6c41fc3e6334f66b4cc8"
    sha256 cellar: :any,                 x86_64_linux:  "87e22fee485303c3a34ae982541892624aabd96d999d83f648ff3b84d020e1fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"k8sgpt", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end