class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.2.tar.gz"
  sha256 "46735f5ad5b40bd8121604fb9b74275eed7a676420b45fa3cec5fff24c764b99"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1a001d07bbf446c4fe09c5fbfa4e5635343570b1aad7cb63630553c650fa4dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b823e64d10afbe629fa6483405d3c4b64f82341660b61a3f528f80c2d2f53519"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9723ad1bebf53727238cc874acfd1a0d7030e6059d379395ada5151f06a482ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac3bae099df99fd0a281571e0881cdaae95c5a659a3860c8b516c0b906b930b2"
    sha256 cellar: :any_skip_relocation, ventura:       "c7ab96e7f691ad2934e9840f680b89d1d95674178d09bf1f27cb109a0db488f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce972ed6a23a0a9600541d5f4449f7810f0b3f7b9e15067d991a9b39c8671916"
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