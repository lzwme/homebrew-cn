class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://ghfast.top/https://github.com/splunk/qbec/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "2789a49d0e3d421fed2db40d9cea0411dc76d759a7e80eec1e77fce201e089d4"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c05bf8e3b78547e57e4c06c5c2dcfdf29a86e3ba1ba58ac5b0593c6ddb7718"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f9f156de37414e1c7d4e993c7c88f24de794e58d95dfde4de9b2b892e2d74d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e1e3bf7294e8787969a00d7b5f7f4d685fc20b02e43046cb1417757ae89600"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab57db399ddfb465dcbb99dec51dd3555c9556e27d5b2c9c9992a4afdc83475e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0c99147cb8bbe99c3ecb288feeba5ea36be2f161bbab1dc3c4f6ac1582abc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda8e0931ba248694966aff7ec3a0477e8551c80d7211f828b5acf93dc772e82"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=#{version}
      -X github.com/splunk/qbec/internal/commands.commit=#{tap.user}
      -X github.com/splunk/qbec/internal/commands.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # only support bash at the moment
    generate_completions_from_executable(bin/"qbec", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qbec version")

    system bin/"qbec", "init", "test"
    assert_path_exists testpath/"test/environments/base.libsonnet"
    assert_match "apiVersion: qbec.io/v1alpha1", (testpath/"test/qbec.yaml").read
  end
end