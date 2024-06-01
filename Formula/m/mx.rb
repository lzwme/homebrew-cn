class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.25.9.tar.gz"
  sha256 "1314089a3871f450012fd3b6965a4d46349ef48baba1a154b4d2d1f263262771"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "312be3542d703ced875b093553675557cfffe14c333a81a95c7f4d637c2631b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "312be3542d703ced875b093553675557cfffe14c333a81a95c7f4d637c2631b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "312be3542d703ced875b093553675557cfffe14c333a81a95c7f4d637c2631b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "312be3542d703ced875b093553675557cfffe14c333a81a95c7f4d637c2631b5"
    sha256 cellar: :any_skip_relocation, ventura:        "312be3542d703ced875b093553675557cfffe14c333a81a95c7f4d637c2631b5"
    sha256 cellar: :any_skip_relocation, monterey:       "312be3542d703ced875b093553675557cfffe14c333a81a95c7f4d637c2631b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ba16768b5daf03df09ade7edd94d06c00be4144d53aeb4064b867ce240a605"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin"mx").write_env_script libexec"mx", MX_PYTHON: "#{Formula["python@3.12"].opt_libexec}binpython"
    bash_completion.install libexec"bash_completionmx" => "mx"
  end

  def post_install
    # Run a simple `mx` command to create required empty directories inside libexec
    Dir.mktmpdir do |tmpdir|
      with_env(HOME: tmpdir) do
        system bin"mx", "--user-home", tmpdir, "version"
      end
    end
  end

  test do
    resource "homebrew-testdata" do
      url "https:github.comoraclegraalarchiverefstagsvm-22.3.2.tar.gz"
      sha256 "77c7801038f0568b3c2ef65924546ae849bd3bf2175e2d248c35ba27fd9d4967"
    end

    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["MX_ALT_OUTPUT_ROOT"] = testpath

    testpath.install resource("homebrew-testdata")
    cd "vm" do
      output = shell_output("#{bin}mx suites")
      assert_match "distributions:", output
    end
  end
end