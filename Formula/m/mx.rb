class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghproxy.com/https://github.com/graalvm/mx/archive/refs/tags/7.0.3.tar.gz"
  sha256 "5e49c7ab7b9b89e7b22c74dff2a7e7f116b2635d9d1b7df97b9ddf943eb14b02"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8153bb50a5e2395907e7b3ab05b6cbf3c2f50a709e7780791d99af7a7961bc99"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.12"].opt_libexec}/bin/python"
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