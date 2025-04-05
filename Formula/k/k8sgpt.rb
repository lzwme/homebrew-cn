class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.3.tar.gz"
  sha256 "546b10a055be7300ad6adb4c973162f6e1d52b2b5311af902517fddf777d18b9"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2fa6a67016480590025d2a065e4843cc1645279e2b066f11a24cc5c7a0340ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f82514560998459abfba1facbab2319d8da82e86c237ec6494774a08c63f23c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f0bd68b1f1902f256b3c97bbe1b510d9078e5bba896f0dc95b4452d8544faea"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9f16d6dd7c1a08754996f7d90cb0785fd096f64f8e85791d29eb2642c9ff501"
    sha256 cellar: :any_skip_relocation, ventura:       "9932724b5c305451d9d153ed6fc262dea9e991ac164697ec8fbda9d43f84fa73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b49a0d845b33d95bcbed88a8f2a5118cfd2c0d8dcfe5c443097a5513508b004"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"k8sgpt", "completion")
  end

  test do
    output = shell_output("#{bin}k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}k8sgpt version")
  end
end