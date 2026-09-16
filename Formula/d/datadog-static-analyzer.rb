class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://ghfast.top/https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.6.tar.gz"
  sha256 "022b4e7d47c9881a8e40679fd97eb139cd8a2f035455f00984a87a190ca973b6"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a8e4dbb67cf014878700183b369c7ec86b9fb4e58ca83f1d44578d0d17216fd8"
    sha256 cellar: :any, arm64_tahoe:       "aef0710262ee14b42e071e65b8e0860b281ee77f89fc6182e9feefb35a3c2257"
    sha256 cellar: :any, arm64_sequoia:     "25295d980f81e41d553a59a0858ec33dbc36172cbca8c5e9354343a31cf667a4"
    sha256 cellar: :any, arm64_linux:       "97d76f42a8e8e161788708fdc7b8ce5a250f20bb9c13e18f05114742bf9ab753"
    sha256 cellar: :any, x86_64_linux:      "3498ee2871a162a7a822df38edbb4591ee3a68a0046cac7802a1671d81fed46d"
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