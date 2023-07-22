class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghproxy.com/https://github.com/graalvm/mx/archive/refs/tags/6.32.0.tar.gz"
  sha256 "b98b063bdf22919600a09ba50268a3b8c420ca5326578aa0e96f290014a49bcd"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "752a1a2bad97c735d4cb6d85d8c9caca0c68f2be9c636e6c88a81c30f906d075"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "752a1a2bad97c735d4cb6d85d8c9caca0c68f2be9c636e6c88a81c30f906d075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "752a1a2bad97c735d4cb6d85d8c9caca0c68f2be9c636e6c88a81c30f906d075"
    sha256 cellar: :any_skip_relocation, ventura:        "752a1a2bad97c735d4cb6d85d8c9caca0c68f2be9c636e6c88a81c30f906d075"
    sha256 cellar: :any_skip_relocation, monterey:       "752a1a2bad97c735d4cb6d85d8c9caca0c68f2be9c636e6c88a81c30f906d075"
    sha256 cellar: :any_skip_relocation, big_sur:        "752a1a2bad97c735d4cb6d85d8c9caca0c68f2be9c636e6c88a81c30f906d075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba46d131e4bee7d34e9e40d1ab1f1be8c95a802a9c9bb0cdb81d2672224c1f55"
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