class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https:github.comwerfnelm"
  url "https:github.comwerfnelmarchiverefstagsv1.5.0.tar.gz"
  sha256 "9507efd171942f2d153adc84bc83bcf3a07f81d5a942ba3936648fb509a6ef18"
  license "Apache-2.0"
  head "https:github.comwerfnelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f51b45dc60439c4021c7a47741dd5b5cfb0a4c96e43b83f096dac1cc4bab56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ad73ac1505b6001484a319f8bfbddda2a89813274d8872a1caae2661a8fa607"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30475833a4ee6b489490dcee04e948c01fcac7fc3c22255eac9cf0f2924a58e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8985099fcbf6b2002645da31dfd09c0cc9ec1b3a6e4084e58ad9f32218de67ad"
    sha256 cellar: :any_skip_relocation, ventura:       "9e1951d2833360d29f4a553a87eb1a786cd94436d7845a4766be374a6a6ddc58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dfb6fbc1d3bcbc6ce3ff5c1a9eb51df4df3f8b609f9be7c3ca873fe007de18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bd048228276460e7cb6267b214ed2fc169bd79ccbd2e4eee5e1a5bc9540c77f"
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