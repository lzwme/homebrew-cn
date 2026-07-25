class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://ghfast.top/https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.0.tar.gz"
  sha256 "4766edbc9d88ccbbb42e1e28ad90af9d3a5e5367541b9829aec12c7c91b641a6"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cb9cba68a2988589a7a584dfce1b6b06870c917eb962afe681b4e01deacc3ff8"
    sha256 cellar: :any, arm64_sequoia: "7447c84c0c2fd4e167ada8c5a88a4f6302eb1a9b4ffdcc56ecbb106de9d3f670"
    sha256 cellar: :any, arm64_sonoma:  "2a9f134a6dee5efb71980353a1d152551edee2659d0f4df907966892100fda8c"
    sha256 cellar: :any, sonoma:        "d1e18d6c9c5367bcbfd9a2b19f5cc47be46000a67fd8ff1c7f0a511f5b4430bb"
    sha256 cellar: :any, arm64_linux:   "8c0670877b8ab0742c1edd5873ecfb5a9feca340bb35c0771b43388b4b9ef880"
    sha256 cellar: :any, x86_64_linux:  "4f4920174022ca4d441ba02fb3f14a54e801730c5b362201becdddc3b4c2c5fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
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