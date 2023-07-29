class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://ghproxy.com/https://github.com/graalvm/mx/archive/refs/tags/6.35.0.tar.gz"
  sha256 "219018cda30b3660a20b1e9dd3c978b79f7d928695cfd1c94435f2925b8254db"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da16d2b3bfe6abf192d4e53a9b06040bce410fe8a39f0d5252ba8b4ea5f4d859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da16d2b3bfe6abf192d4e53a9b06040bce410fe8a39f0d5252ba8b4ea5f4d859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da16d2b3bfe6abf192d4e53a9b06040bce410fe8a39f0d5252ba8b4ea5f4d859"
    sha256 cellar: :any_skip_relocation, ventura:        "da16d2b3bfe6abf192d4e53a9b06040bce410fe8a39f0d5252ba8b4ea5f4d859"
    sha256 cellar: :any_skip_relocation, monterey:       "da16d2b3bfe6abf192d4e53a9b06040bce410fe8a39f0d5252ba8b4ea5f4d859"
    sha256 cellar: :any_skip_relocation, big_sur:        "da16d2b3bfe6abf192d4e53a9b06040bce410fe8a39f0d5252ba8b4ea5f4d859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4a31866cafdac847d1704ee20ff323e2fb3cb983f2cd00d32ca0bd68b9fe00d"
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