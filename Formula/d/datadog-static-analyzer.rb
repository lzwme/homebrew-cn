class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://ghfast.top/https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.3.tar.gz"
  sha256 "a81047bed6901ad00b02e5fd7da142a2b0526971258d33c7f5d1af8af1929997"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "08470e25e9da91192b69e633c8783ea205d1d51402c18d4ba7e0244e13b3725f"
    sha256 cellar: :any, arm64_sequoia: "11538eecb4fe0fd7df257741f83e21aa19a7b614777ab7a553f8d2c348931764"
    sha256 cellar: :any, arm64_sonoma:  "57622a162ed3ce98de75c37e1826f10f83d3fd90ada2aeba29f367f988b9d570"
    sha256 cellar: :any, arm64_linux:   "b0929c2e52bd98950819e9a4f3e9dd963a4cf555f85a40baf98a5305c884a27c"
    sha256 cellar: :any, x86_64_linux:  "1994bfad6dd116bf511008d7a937c076834b2a3e9abb3184c0eb7e44c6c64409"
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