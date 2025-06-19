class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https:github.comwerfnelm"
  url "https:github.comwerfnelmarchiverefstagsv1.7.0.tar.gz"
  sha256 "5e32d9cf1a6053bc5a2adbacfbcd791e8e73ca43456e0891f3f590688594320a"
  license "Apache-2.0"
  head "https:github.comwerfnelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6c3c9856931f220b5c0e1e0d498cfabd841e4cb0f03d92a78c350e37e582f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f079679e7c43956e779fd4f5a610dcbf6c929c3aa64e9267ab968b3e8df5907"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd04ac791a265e1737a44c256506c906dfc1074133eaaf5c9c9715d829940d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "43a68aecb01d19476d2f40bac6fb4ebe742aefc7308dc9d190981c46117fc5c3"
    sha256 cellar: :any_skip_relocation, ventura:       "60be66ea85300b8c11530b79496dad2f22ca2f5773266b61abc8600d07fd9cae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a4ec46df0775341ce7af9c3bbcfea7bc86ee60859664507db1f227da45d1eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "260358569eaa9b6722d347a161b1e3fa2df1b962f29a9845b40f6d75c8322a2b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comwerfnelminternalcommon.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdnelm"

    generate_completions_from_executable(bin"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nelm version")

    (testpath"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https:127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}nelm chart dependency download 2>&1", 1)
  end
end