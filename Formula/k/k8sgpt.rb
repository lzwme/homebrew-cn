class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.1.tar.gz"
  sha256 "d7896ac976c7f04c93e5c77bccc594bf618e3328a91d07302170c5c776fb09e2"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dca0122a71ed74f8380791d12d6b81759cc543cbab4fab100b0899eb77a2ff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be052f289f636d5013cf6c3298d3e9ed6820f0367f8116596f8799dd567ab33c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "245f1889c31603eb8c0f946a0c33b66805b9e1d85709c102ce70d9f8997fb53d"
    sha256 cellar: :any_skip_relocation, sonoma:        "357fe9d6b47275ec492b4a24c260f41410d85c13112876d32277d841320d75ed"
    sha256 cellar: :any_skip_relocation, ventura:       "5cfbfd58ad673c1016b643be80c48f50396beb92f4727c9760f0d304f698cffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff251dc9a1d570188be17d5d29d03e822dd92a7fd3cc66465677d729b649ce4e"
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