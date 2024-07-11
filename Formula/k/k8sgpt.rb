class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.38.tar.gz"
  sha256 "d6e9dd181b0ae8cee3197b941507610cd0999c4862d3c90b6ed23f6573ea4947"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "242cefc99ff9abcd35f009a0e08fd467984a90f97b4e635f8a7c184891fc4d3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "219be1ea0b9add38daf474e1c1d6a60e92c585b1da2be8c74a09fc61c5714145"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19d039721b1a520e2020d24f4886ff2f8c85c65ed9cc09ba3a896e45a495c212"
    sha256 cellar: :any_skip_relocation, sonoma:         "eca5ce9a2d83895b6bbcf796498b2f9b60f8b917f767030ede2952fee0b14424"
    sha256 cellar: :any_skip_relocation, ventura:        "713972c5f8eb550b410b4152a7b14199c4f4891cf0af1a3bd4ed5476e6bcf447"
    sha256 cellar: :any_skip_relocation, monterey:       "6f4668a2d33ea930daa4afe13992ec59f89b58843f915917c5a609cc6aa6de81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "754398393818ea6797cbf28a28d4bc978d454df81e42f74da1e9767bea8765b8"
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