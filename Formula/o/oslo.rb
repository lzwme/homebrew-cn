class Oslo < Formula
  desc "CLI tool for the OpenSLO spec"
  homepage "https://openslo.com/"
  url "https://ghproxy.com/https://github.com/OpenSLO/oslo/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "ee43704402d8867e952bc02086da4ec175a405599ffe3ac654053e9245ff10f7"
  license "Apache-2.0"
  head "https://github.com/openslo/oslo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8683f78264b1e09294fa3d84fa0f27d0519c2212ad408c06c2910e26bf1483b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30acddc46ade3dfafde77909568ff5dbc365365eaf8a04fa8684d52790c233c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cc2e5bf21728181c866c176de73143cc8b868696f69c439dce034969d9e3dc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f0ad1e5922520937f86068721d1161851047c0bbd16e77a47e2fb7efffc6ca3"
    sha256 cellar: :any_skip_relocation, ventura:        "70304446419104b0ca04b37f542371cab148570b5d18bc09662a4bf1e3a6c6bc"
    sha256 cellar: :any_skip_relocation, monterey:       "54295eaf3564e40f085a1b1f8adb4cd12b4b0513da419006b6525665334accec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6913e40ef59f049df1c0c95480a1a5b0aa9330c42e71b1501ad98242400d0645"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"oslo", "completion")

    pkgshare.install "examples"
  end

  test do
    test_file = pkgshare/"examples/definitions/slo.yaml"
    assert_match "Valid!", shell_output("#{bin}/oslo validate -f #{test_file}")

    output = shell_output("#{bin}/oslo convert -f #{test_file} -o nobl9 2>&1", 1)
    assert_match "the convert command is only supported for apiVersion 'openslo/v1'", output
  end
end