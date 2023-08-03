class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghproxy.com/https://github.com/graalvm/mx/archive/refs/tags/6.37.0.tar.gz"
  sha256 "7a5c710aff526953390ca514eab6b8bb8c1a5b705f08207965caf136e51d3968"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7add9a51018a51b910577e2be772a72d84034d99a518a3c6d3f85efb4a216ce7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7add9a51018a51b910577e2be772a72d84034d99a518a3c6d3f85efb4a216ce7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7add9a51018a51b910577e2be772a72d84034d99a518a3c6d3f85efb4a216ce7"
    sha256 cellar: :any_skip_relocation, ventura:        "7add9a51018a51b910577e2be772a72d84034d99a518a3c6d3f85efb4a216ce7"
    sha256 cellar: :any_skip_relocation, monterey:       "7add9a51018a51b910577e2be772a72d84034d99a518a3c6d3f85efb4a216ce7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7add9a51018a51b910577e2be772a72d84034d99a518a3c6d3f85efb4a216ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcf1da609d960bade0ce5be2d7a07747847bc55974250e7607641d972fb19a05"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.11"

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.11"].opt_libexec}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"
  end

  def post_install
    # Run a simple `mx` command to create required empty directories inside libexec
    Dir.mktmpdir do |tmpdir|
      system bin/"mx", "--user-home", tmpdir, "version"
    end
  end

  test do
    resource "homebrew-testdata" do
      url "https://ghproxy.com/https://github.com/oracle/graal/archive/refs/tags/vm-22.3.2.tar.gz"
      sha256 "77c7801038f0568b3c2ef65924546ae849bd3bf2175e2d248c35ba27fd9d4967"
    end

    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["MX_ALT_OUTPUT_ROOT"] = testpath

    testpath.install resource("homebrew-testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end