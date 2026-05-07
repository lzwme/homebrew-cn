class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghfast.top/https://github.com/graalvm/mx/archive/refs/tags/7.80.0.tar.gz"
  sha256 "d52323d4daff048bf3f49240e91a22664ff0b25f96935909f26e2a916d05c100"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5fa61286349e6b1f453739aea39d0a2d5eac9f6c5958d01508010689a70a672"
  end

  depends_on "openjdk" => [:build, :test]
  depends_on "python@3.14"

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.14"].opt_libexec}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"

    # Run a simple `mx` command to create required directories inside libexec
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV.remove "PATH", Superenv.shims_path # avoid ninja shim
    chmod 0555, bin/"mx"
    system bin/"mx", "version"
  end

  test do
    resource "homebrew-testdata" do
      url "https://ghfast.top/https://github.com/oracle/graal/archive/refs/tags/vm-25.0.2.tar.gz"
      sha256 "129261a9c43d43ca8cad235b65ee9cf8bfa9a2e2d51e90ac188e3cf5174323a0"
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