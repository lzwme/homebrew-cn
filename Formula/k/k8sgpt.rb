class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.9.tar.gz"
  sha256 "1ada858b354665cfacd4ce4233dfba022f88705727607762138ded71622b718a"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72bc6c033a4e8657ade939acdef3a321127e9e514d61b8fd11655b0fbb3723c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf7807623361350c4d4facb62c6c30c5b54c03c5994b5ca33bdda870545c265"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bec23e47500464fbedcddeacc3e0e46858a3d5efd046b6e1870ea930f2f262f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "037a532d3e2f36a68424a022ed50412b098f9e15784faf372784a1c610d443b2"
    sha256 cellar: :any_skip_relocation, ventura:       "5a7898347e1fea0029979e385737f24cb4a613d5fa1c4c3d799b6cc56e6d5b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e09646005f320953ff3798c3c2bade87001008ed876c515affa107253b0245c"
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