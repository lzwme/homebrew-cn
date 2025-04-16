class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.11.tar.gz"
  sha256 "f18886490964ac3983316392c5b778ffd64e63942b62bf5c5e06ae0aa94c3ed0"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05839320e9a8c6ca2a6728e97f02f933792bc996fedfcbc4b23c5468c50280e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a11dbca9dc89398efc0a6722804efd9d024d6dbb47a5f65954e57b8c318d424f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "392dbfda43be7abe36f8f52ce451545132429ff0623698e68ead4d8a58230004"
    sha256 cellar: :any_skip_relocation, sonoma:        "acb680a9b8d01b97d7d35545fbe66e777cc395258b0a72ebbfdb262c8424f36d"
    sha256 cellar: :any_skip_relocation, ventura:       "fda3fc3d15eaa1116c16eca43055265b7a0a2da1477a236fad89a69be423130a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db33a2986dd48697e63cfed62227ba3eaee31cbaeb74baf75418fef13005604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9494ec12182466d09305d4a244eab861c9ed2c7ea4519f0a8a3f745431a3a97e"
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