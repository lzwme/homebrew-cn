class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghproxy.com/https://github.com/graalvm/mx/archive/refs/tags/6.30.0.tar.gz"
  sha256 "764bf57305eafc16374164aed54e459a813324addfd884ee56e0f2f14333fade"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bac13adf25792a391568dd1fb361f44ace096ee70256b4c395d3a8ea6aacfc06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bac13adf25792a391568dd1fb361f44ace096ee70256b4c395d3a8ea6aacfc06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bac13adf25792a391568dd1fb361f44ace096ee70256b4c395d3a8ea6aacfc06"
    sha256 cellar: :any_skip_relocation, ventura:        "bac13adf25792a391568dd1fb361f44ace096ee70256b4c395d3a8ea6aacfc06"
    sha256 cellar: :any_skip_relocation, monterey:       "bac13adf25792a391568dd1fb361f44ace096ee70256b4c395d3a8ea6aacfc06"
    sha256 cellar: :any_skip_relocation, big_sur:        "bac13adf25792a391568dd1fb361f44ace096ee70256b4c395d3a8ea6aacfc06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a739d3064c260795644e612abdd26235fc1022573e97f3061ffa3ed58ecdb39"
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