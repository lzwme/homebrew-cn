class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "006e96489a911d29b05000599b8eaeb0dd020eb79d7030538475c9515089fd6e"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26397f3a39207b34f70c198d36822dfdd23f251550c7a91537c84b109cdae918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "864507ae61acb1553bc9cf468d0344062a1910692a9010acdd43799712a7a379"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bce39ec29169db19f7b709d6425f418dc141dc91089859f2dadab6ec3b0ebda"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c5ae04a500decf5e1d82c185e4bc3dd7a4d2215af7fd4029d65384d19a0debe"
    sha256 cellar: :any_skip_relocation, ventura:       "978b8d0fcf424a611af74a5df69f2dca6124aa7dcc68bbfbc3367c66fc9ae5c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e5a6aae0125e3261f3d9d6c1f6889258d1bfa572ef5f23235a54c5f215d71c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8987e826036877369ae84cf9dfaff000778361d78196dcc9c3df1a0ebe6aed13"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/internal/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end