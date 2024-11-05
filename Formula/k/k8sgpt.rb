class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.42.tar.gz"
  sha256 "0a8e5cc1599df1b2bc4813a5beb66573de104b501790aadf95f62b5ba22dc809"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b99b65fd69007f30b200aa942d3b313d9959d7ae2d7cd188dd0768a4e029a905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2244a2abb8634a6b113571f4c33a4b05a372942771f3b679cd86fadd71fee0ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9f3e527e3adb9132761ff220baf06b3e7f2d1ef749cd735caa633d145c6e094"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ecefb3efa3bf7e73f1bfb215adbfd4f4034517089b3fcc5f8027dd8915a400"
    sha256 cellar: :any_skip_relocation, ventura:       "df07aef9a991e969251ab2edd99da9df5c3e68ac9970110a50d9e92f05c475b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e72e5dcacccfc96fdd74289bc6bf6e9553cd0ad7ee70b355444a6657ab05914e"
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