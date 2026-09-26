class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://ghfast.top/https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.8.tar.gz"
  sha256 "793164c5defd1eeefd2907e60dec00dbe0d8c05f45915af546a0b012ca693b0e"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "76226da7760e7e9da83059d26b85c0706521c429451457b4de7d76bf84a746d8"
    sha256 cellar: :any, arm64_tahoe:       "a2a76ed543656d5ddc35c97f1a6935ab0ee69e7e51c4e2b9b85228ff5b12726c"
    sha256 cellar: :any, arm64_sequoia:     "544480b8f02eab8ad462189d009f29972e7354db1e6bbeb58a06dacf9a1534c9"
    sha256 cellar: :any, arm64_linux:       "072858df9a4aff50558e432cdb90832546ee8dd932bf4047beb4cb8a843c0456"
    sha256 cellar: :any, x86_64_linux:      "b34fa98012321840c8423faf9beba91154ab0ae9c94004e8c391333709402f48"
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