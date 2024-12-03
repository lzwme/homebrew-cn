class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.47.tar.gz"
  sha256 "561360f507d611ac5d210e24024346ebb2d15c7b56f1ba5b3c97cb6c9b3755e2"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63b791e4f3661cfb751d998dee5d0745dfa90aea656c33e4f9a716d6342f7649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f90f6436b2856038a0753731033b0999b18f891279a683d11dc0e8793373d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db013d60e5965e432c4327d1a30bae3d25fd14ac128916d99d1b07c34a449da9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f66fa475d61567f6cf39db74a5c6605ebd36a7d3cd373cafd1cbc8c5e41231ce"
    sha256 cellar: :any_skip_relocation, ventura:       "e555ed5bd0ed6f172a1ac73d8d0f927f0785609ba85081305b11266a103379cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e133f8e36e0ca4210d5ee4b67fee3fd393d72ce03bb8070d77638bc82d270fc1"
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