class Iceberg < Formula
  desc "Command-line interface for Apache Iceberg"
  homepage "https://go.iceberg.apache.org/cli.html"
  url "https://ghfast.top/https://github.com/apache/iceberg-go/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3bf2bb338676161db4896b1748879cc211ea12d9ad9ea5dd845dde12af271249"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b362e2d7e85e08fa6b8f902d77fc519fc096a08d68d1c8ee68b08993c65e9996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b362e2d7e85e08fa6b8f902d77fc519fc096a08d68d1c8ee68b08993c65e9996"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b362e2d7e85e08fa6b8f902d77fc519fc096a08d68d1c8ee68b08993c65e9996"
    sha256 cellar: :any_skip_relocation, sonoma:        "410dfe015077c35d134318e84a478cb8836be97000994862e0efba5ecf639d5d"
    sha256 cellar: :any_skip_relocation, ventura:       "410dfe015077c35d134318e84a478cb8836be97000994862e0efba5ecf639d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9a671a01b1a587f7f0eb495d1477f3cf6082a3bd6012a0f23c2de054a04d3b4"
  end

  depends_on "go" => :build

  def install
    # See: https://github.com/apache/iceberg-go/pull/531
    inreplace "utils.go", "(unknown version)", version.to_s

    system "go", "build", *std_go_args, "./cmd/iceberg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iceberg --version")
    output = shell_output("#{bin}/iceberg list 2>&1", 1)
    assert_match "unsupported protocol scheme", output
  end
end