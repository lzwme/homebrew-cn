class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.16.tar.gz"
  sha256 "5db2042f2f9328d080bd4aba71039837f9689939e0809116b8b6204c8829cf92"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1a1665ae820a6920af75fd14c1a4861b90166c773228dedee52c1709a618f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0a791c075a00670fb8e11bed2ba714487c1af435e0111644ab38a2e965aa43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8b260926bafe51e3a4eecddc3ee38e7e107b2e547989d1b5696a175b6d56422"
    sha256 cellar: :any_skip_relocation, sonoma:        "1988f8edc6fca1b153f271ce7c1a3247453d7da1ce64b84cfd64c59f2ff99511"
    sha256 cellar: :any_skip_relocation, ventura:       "2f7e8ecb7bdd281cef917a5915c9a795be11e132d3921d574cb7743a97af2e74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2691fd0b07bd6a8966577a0252ebec07c16bc771a4d4df6290a5d2245c48c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03393205837a5e3b867fc93ece7d18221edbe1bd7406550ae7243946571ab036"
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