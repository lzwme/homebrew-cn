class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghproxy.com/https://github.com/graalvm/mx/archive/refs/tags/6.34.0.tar.gz"
  sha256 "7bf3e5fd3fef7e27f62bb1cbfea5922188fa615f1174e19abbbd9dfe044781ae"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb2c04fd4509e23ae77fdb80be49476c296093abddd46fabfb18e8ab956c784f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb2c04fd4509e23ae77fdb80be49476c296093abddd46fabfb18e8ab956c784f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb2c04fd4509e23ae77fdb80be49476c296093abddd46fabfb18e8ab956c784f"
    sha256 cellar: :any_skip_relocation, ventura:        "fb2c04fd4509e23ae77fdb80be49476c296093abddd46fabfb18e8ab956c784f"
    sha256 cellar: :any_skip_relocation, monterey:       "fb2c04fd4509e23ae77fdb80be49476c296093abddd46fabfb18e8ab956c784f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2c04fd4509e23ae77fdb80be49476c296093abddd46fabfb18e8ab956c784f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80401e7af92ac26d4a90d48d0930eb0219615a3afe8325efc60b7b566a0dd102"
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