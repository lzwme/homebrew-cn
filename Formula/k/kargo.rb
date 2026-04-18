class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "e6f2542a07a3fbf3782ba69884d1e6fffa52a40782dca8356753759462e69e7d"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12d831ff06f1036ac8a4bb9a66164508d95ed0460b13ddfa80dadbe9fd9a6904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "787fd7b3a60c3032dbdfb5db20382ff5f1b3e4d90998b25c435fa530d5a19116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91443da7f68f4d815e55104c9914dd1a5e2f6ca621bbec16f2d2fbab03bb7e2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b9acf618790974234cd566622ae261350567248d869c65a8e6101f4d689791e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cf17c896bfbae1ac78f99514a22f81cd63664d1bc0a2fc912c4dec19f2771d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2695e61949dccc8966046f09b5ec62e0d95309b43eaa4b6ef2a055042f6fb670"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end