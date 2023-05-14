class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghproxy.com/https://github.com/graalvm/mx/archive/refs/tags/6.23.3.tar.gz"
  sha256 "3b813377499977345412d2da0ce0bd280db2192ed5ff7df005d3d2ed4e31aa82"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0a7a9d92646808c639afdc3f174a7866e203ab7449834099d394d9dcd17e6db"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.11"

  resource "homebrew-testdata" do
    url "https://ghproxy.com/https://github.com/oracle/graal/archive/refs/tags/vm-22.3.0.tar.gz"
    sha256 "410a003b8bab17af86fbc072d549e02e795b862a8396d08af9794febee17bad4"
  end

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
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["MX_ALT_OUTPUT_ROOT"] = testpath

    testpath.install resource("homebrew-testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end