class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.25.tar.gz"
  sha256 "db8304df35089fb69eb16b8720f902dee508f1cbbec2ed4015a8d343d8701868"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b125fc1c59cbe3c2f40e308a1b59335e24d01d40de9e8c8c532ff0806c58772e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b9f47f34876cd66dc26d3fdc0004b3a303be304e5457f8689fc11eeecec5473"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "738027837ec9cf1455e94b993f7567a8b34737400c58acf1f0254a66f475bc34"
    sha256 cellar: :any_skip_relocation, sonoma:         "660db34585ab85e243488615e8d3c3f31b0b445498237949e6a00516158cbce6"
    sha256 cellar: :any_skip_relocation, ventura:        "1f2091334f8d8db39fe70d22453a52158391c57a792aac0ac06484a9c0653a50"
    sha256 cellar: :any_skip_relocation, monterey:       "1d387656bc6884d5f4632a9af5d7a4024e2260b96e93a218751da7bff0ea069c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24bc6361c233364ebc19e20113f952e656705ae8172d4d1833775528c36efc64"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}k8sgpt version")
  end
end