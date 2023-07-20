class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghproxy.com/https://github.com/graalvm/mx/archive/refs/tags/6.31.0.tar.gz"
  sha256 "078a07ec325082c5d10e5a76dbb6b1e00ba872845065adcbd404c3d99cb398c5"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe6a51ea113b3a8face68eaa7eec076335b1c11a6bdf605bf86a81b6f11beee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbe6a51ea113b3a8face68eaa7eec076335b1c11a6bdf605bf86a81b6f11beee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbe6a51ea113b3a8face68eaa7eec076335b1c11a6bdf605bf86a81b6f11beee"
    sha256 cellar: :any_skip_relocation, ventura:        "bbe6a51ea113b3a8face68eaa7eec076335b1c11a6bdf605bf86a81b6f11beee"
    sha256 cellar: :any_skip_relocation, monterey:       "bbe6a51ea113b3a8face68eaa7eec076335b1c11a6bdf605bf86a81b6f11beee"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbe6a51ea113b3a8face68eaa7eec076335b1c11a6bdf605bf86a81b6f11beee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6a51235a5469027b4be4e93d1df018e3ac6797df5be8f85e85ebdf45c1b572f"
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