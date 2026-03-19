class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://ghfast.top/https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "d2c37b3824486ec1fe2613b22844c1f205aa0ea5232c380eae4428281ee4dc12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84dc1887bf1d29e53942653fe420615cdfeb23b4900b69f607420bc75447e781"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7114310f0e33f4f5007009265803814814d3a948547f59997897e5aff425b147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddff81e4dd7875fdf4aae0263367282a75953ae6455b3c230db946f3fc4a3a28"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d097abf05cac72327c32a0fe253bdb70b211d8792727cb2f2271743e9dec1cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f8487bc1486271cbc58ff11be8f7c5a6c389ec43624a25ddcc82cee84c1cf5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2f0694aa9aec9609c2e6d48d6d28c7af63ded569df0ebdac0ab06dac434968b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w  -X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bento --version")

    (testpath/"config.yaml").write <<~YAML
      input:
        stdin: {}#{" "}

      pipeline:
        processors:
          - mapping: root = content().uppercase()

      output:
        stdout: {}
    YAML

    output = shell_output("echo foobar | bento -c #{testpath}/config.yaml")
    assert_match "FOOBAR", output
  end
end