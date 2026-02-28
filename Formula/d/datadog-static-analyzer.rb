class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://ghfast.top/https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.7.7.tar.gz"
  sha256 "7f9064739bcaa7dc1db932bb72aaf83ff50847fe31ea96bf44b3e804386719b4"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16daf8e44fd5e05856faf2e0cfa7350934eae9b733ad00e417633fb892b6cd93"
    sha256 cellar: :any,                 arm64_sequoia: "002b5c7c3fcc4244046885ace5dd414a8c028f00be55c8f6f42f6d589a0780c2"
    sha256 cellar: :any,                 arm64_sonoma:  "fefc99983e399a275ea07a380fc9b92dcdbc80a8e8498b7b55a555a75777d754"
    sha256 cellar: :any,                 sonoma:        "ab72baaec23c16728bbd5272552a33bb64f9a7e5e212ddd8f9b550e5de36c65c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90ea32fd009a51dfe82cbccde3a424e34b018d12845322110f1ac0c597436b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8759faef6f60112a2dd132b60e9cfbb2b7e411625d17ce0a7bb8c99a16777ad"
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