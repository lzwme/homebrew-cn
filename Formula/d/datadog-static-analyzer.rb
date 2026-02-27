class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://ghfast.top/https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.7.6.tar.gz"
  sha256 "cab958276640697a65cb88dfa224cc69f4669d978e9dbd422a9313d50cf02724"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e7e0fe12fc4440795b2f0a7e4d3f67371def5349bc80bd6bb144c5d7740ca2b"
    sha256 cellar: :any,                 arm64_sequoia: "d33302f3fdeefa37d45d13afcecd45c9c53d6777eff62f42bcba9be81e2a9545"
    sha256 cellar: :any,                 arm64_sonoma:  "88455552a7d4210a0dba6cf31a2801c90bf44048eddb4c5a5953e54db1e992ed"
    sha256 cellar: :any,                 sonoma:        "7ab823aa091c6b283c2159655e45cc504e974f3485ee7e348bcbe35c0961ddb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81352ad9152a31e51c0c22f310e1c3866ce03c26540a4138b1016f11debe252e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b550abab33dfe89ca08e1a2bc7fab855335640d531945831dcfd1686cc27c3"
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
    assert_match "Found", output
    assert_path_exists testpath/"output.sarif"
  end
end