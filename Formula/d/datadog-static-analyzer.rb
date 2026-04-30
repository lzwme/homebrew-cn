class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://ghfast.top/https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.8.3.tar.gz"
  sha256 "003270772ea540f0f3bddaaddad163aecb48cf81816033487972d17081391184"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bfee5e48685ca3dc6cf4d077308d72690c557c793be310688722e325e0d61e8"
    sha256 cellar: :any,                 arm64_sequoia: "0b876d2f160537cf0c53ce8f12611ab47e4ec44e9e0662aa25e146fcd7448d51"
    sha256 cellar: :any,                 arm64_sonoma:  "2b56ff0793bee1e0907c2daadc28aceff4d141f6ffd39c32a89610ad72101552"
    sha256 cellar: :any,                 sonoma:        "a669317b55f404f0392142a2180472e7918a27ade50badd69bdec1653ae8f5b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cc5d5b9d0ca545e3d3ecf5b238c4294a1a3e9b052ea785b8b141ad4c1d63ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b70f102d1392fa19ad85f707967f1dc0a76e490fabbd9aed959fe71ae0c73443"
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