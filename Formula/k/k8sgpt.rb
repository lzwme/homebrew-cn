class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.33.tar.gz"
  sha256 "bec7faf182786b95d94142d67966270bb22412f0cc5b37ac870cd3df249b52e7"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66c7c249855d147e2a70f80bd82c310394b6aab560efb70ad08bd971c757c428"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "618540756a7585bc0205c4cce0b7dbf60ef345ddd444a7aa0aa21ebf14a4acd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7b69c994a7c4af55de9812add46607a19dcc30305edd8866a25fa2a8316a0e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f7e3f5fdd3a6db44ba503f72a593ca0ef0bbec93d0b93a76cbe34920b8ec24a"
    sha256 cellar: :any_skip_relocation, ventura:        "81bcd559abf3998554fa82a411c8b2e2d5d7da82e0dd0dedb37251407db552dd"
    sha256 cellar: :any_skip_relocation, monterey:       "8c42f2f52a51ccebd219e8c8ee0adc92d66a807b62a290d302e1b71536444ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85387fc7c4f63d4083ad9865554f12b69d21e6613235693cc4e9920e63b01438"
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