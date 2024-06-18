class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.37.tar.gz"
  sha256 "30cf355e51c3baa2a62c690ff57eaf1ac4b88e1b6898626a4dd61670bc435822"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cffa587565ea61a708176a72c3ddc66990e756d6c1984252ac27f0f4e2eaac12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "149f308aaebcff1792d15c6afea14f695d6197a5ded068c36fa8bc8c3e2b7548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c4b0d7b6403a0491ebcd3a5ff1e5e363a53f817e4b775e892d6f21730118461"
    sha256 cellar: :any_skip_relocation, sonoma:         "33932061a8ebbfc8982ccfa455c87fa742090e4bd4611fadfdf99e80143b3096"
    sha256 cellar: :any_skip_relocation, ventura:        "6547039d51c82c445d95da37cc7e6d35dd6a0efbd7afa290ff109a1fd841432f"
    sha256 cellar: :any_skip_relocation, monterey:       "bad9eaf167c979f79c2a11797a03e9fd5fcc87568d30abb3c933a22b8dee0912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6bd141b9ed7c35a22e0d8aa0d02a8123ed561250c94ef3ea90b76383f35569"
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