class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.44.tar.gz"
  sha256 "647c70c1d1bd586c880db7be65b301b05e69826bab034b6e2b7e3dae3c859560"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad208a76ab129c6d3bb17a862b239e700a4242192d3250eb1b5d82f6ca4fc159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31427a440244e9605df84ca20937902900af37117c4e60e9f9b1dd18e527d11f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bbc40f3ba52209a8a75c8b7ca7511ffeb4f7ec33336cf1324937a799a3ad63c"
    sha256 cellar: :any_skip_relocation, sonoma:        "67d6e1cc97a5f2300cd0e4ce3831013b9fc79bb76195a203ef618e122b538617"
    sha256 cellar: :any_skip_relocation, ventura:       "80b8966a6e1c80aa6789a3d5e166c82071f502b892ed49892cc7abee634e1a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94438bf2461ca52dcc9f9d038f0f409bcded83e2e993aa4ce14954a4a633371e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}k8sgpt version")
  end
end