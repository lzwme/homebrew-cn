class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://ghfast.top/https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.8.5.tar.gz"
  sha256 "e7266293b0f721991fc871f8fd6b63271ca4011174ff5e3d2de895642107993e"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9a2f612822b01453c1d368fed58e7af6e6a22c70b064e1dd34b8d2f85530b279"
    sha256 cellar: :any, arm64_sequoia: "a7d7fc844caddc9cb150c4728f2092c0b088137bc1e1d9a25f50632e572e7db1"
    sha256 cellar: :any, arm64_sonoma:  "8a0aca7ecdadad1215a49f9288c84beaeeddbb653529c03bda95f100d59285f7"
    sha256 cellar: :any, sonoma:        "0b567c17485f71f8042ee044dce37a220c1fef0def063dfc39e36932e03ddff5"
    sha256 cellar: :any, arm64_linux:   "6c1c5e0c98e353b8dc9e9332c0c96dee27e795c3a4e94f8f5457c3b54e652253"
    sha256 cellar: :any, x86_64_linux:  "69d8203b80ba46c3dc3587962d88338425d3ec1f37031ab65d699e0f3af46090"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", "--bin", "datadog-static-analyzer",
                               "--bin", "datadog-static-analyzer-git-hook",
                               *std_cargo_args(path: "crates/bins")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datadog-static-analyzer --version")

    (testpath/"test.py").write "import os\n"
    (testpath/"static-analysis.datadog.yml").write <<~YAML
      rulesets:
        - python-best-practices
    YAML
    output = shell_output("#{bin}/datadog-static-analyzer -i #{testpath} -f sarif " \
                          "-o #{testpath}/output.sarif")
    assert_match "Static Analysis Summary", output
    assert_path_exists testpath/"output.sarif"
  end
end