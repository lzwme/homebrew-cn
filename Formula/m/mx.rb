class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghfast.top/https://github.com/graalvm/mx/archive/refs/tags/7.68.12.tar.gz"
  sha256 "74f4e667c969df598b32f4f034536dc0d60a4b2f72c6163568e2d9c4c35d3f63"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2502dc4387f867e424db24886694a218793ccdd9d26795121394617cdbe3aaa1"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.14"

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.14"].opt_libexec}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"

    # Run a simple `mx` command to create required directories inside libexec
    ENV.remove "PATH", Superenv.shims_path # avoid ninja shim
    chmod 0555, bin/"mx"
    system bin/"mx", "version"
  end

  test do
    resource "homebrew-testdata" do
      url "https://ghfast.top/https://github.com/oracle/graal/archive/refs/tags/vm-22.3.2.tar.gz"
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