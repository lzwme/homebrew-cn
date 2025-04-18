class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.12.tar.gz"
  sha256 "bcb1c7700ffbb8b08077fcfb449482a1974f7f56bc8cac5ad44464a4d5841765"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bb96347f1f970261670badd97dba3c5d5a82ee54372a49944c147341f68aa76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16714ea31d28404fc5398c8fa84232ca466280c2620cef89ec20bb1305697756"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3277aa7efeb8d96155cf789304331cdaedfb27c9dcba8128e035fae2706f45d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a22af8228938befdbdc912ecc89a281907d1f80fbfaed4a62e45973e4a06b10"
    sha256 cellar: :any_skip_relocation, ventura:       "01df0d785f33598e5669a08ac3ac2d2db7672fd367a7c916b04fb89edf79fa02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94bc708d9833f797bdc8822f5f1eb3f14aaad883a4ee8be775367c72088d823d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972f0d7086b458803581873aefdc0075c54711fd57f072c592416b4f75f211d6"
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