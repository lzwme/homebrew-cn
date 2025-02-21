class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.49.tar.gz"
  sha256 "9478a3728f737d04bc1e849e89d4ee484605966ad63812ede9e3187b6d05f6e5"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f79e2c3adf5545fd846d431640838ed0e73d554ba5b610a79d4e1efbce7b1cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e56184c6e6356b5482893dec5b05dd8619b2f5e22ac7b4ba19067ad66ab42a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b98feef65928a4feea88193b763a902f087fa0fca4c615a88e29a8b2f090dbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b41ffe0fe17fa49c27eecba68875b68e6ac236a502ae52a9b820ccb134d4491"
    sha256 cellar: :any_skip_relocation, ventura:       "c2bae54701573063c455f5e642fb29fa4c42925c92ff7fc6160d57db8c1c1755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee0d18aad6cdabca773cd9b70db75f36bb141444ad5286567b5a6217bd4eb05d"
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