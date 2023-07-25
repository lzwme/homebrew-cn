class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghproxy.com/https://github.com/graalvm/mx/archive/refs/tags/6.33.0.tar.gz"
  sha256 "560cef09e1efd2f2300607f1a702c44e7578743b2138d30a8ec2852378965e88"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07c49f693f5cf489a1ac41ecd5b6501a18f0a8ea5b7803c17cffee24b9bee16b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07c49f693f5cf489a1ac41ecd5b6501a18f0a8ea5b7803c17cffee24b9bee16b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07c49f693f5cf489a1ac41ecd5b6501a18f0a8ea5b7803c17cffee24b9bee16b"
    sha256 cellar: :any_skip_relocation, ventura:        "07c49f693f5cf489a1ac41ecd5b6501a18f0a8ea5b7803c17cffee24b9bee16b"
    sha256 cellar: :any_skip_relocation, monterey:       "07c49f693f5cf489a1ac41ecd5b6501a18f0a8ea5b7803c17cffee24b9bee16b"
    sha256 cellar: :any_skip_relocation, big_sur:        "07c49f693f5cf489a1ac41ecd5b6501a18f0a8ea5b7803c17cffee24b9bee16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d5991876481cb35d5a837127377d18d7b63de3e55f6a7287b388ff08fca15c"
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