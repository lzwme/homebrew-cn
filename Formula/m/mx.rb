class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.28.0.tar.gz"
  sha256 "e8e3bd5dce67995b5c87d940e34a97e3ebfdc6b2d2eaada2de00a2aeb8db6bd9"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4c3b2640889ab040d688b348ff1f150adc7238fbebaf4d0744b4cd92edb94f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4c3b2640889ab040d688b348ff1f150adc7238fbebaf4d0744b4cd92edb94f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4c3b2640889ab040d688b348ff1f150adc7238fbebaf4d0744b4cd92edb94f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4c3b2640889ab040d688b348ff1f150adc7238fbebaf4d0744b4cd92edb94f9"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c3b2640889ab040d688b348ff1f150adc7238fbebaf4d0744b4cd92edb94f9"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c3b2640889ab040d688b348ff1f150adc7238fbebaf4d0744b4cd92edb94f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63f96f657b4ccfc28193e9d424fe1af21c7dbd3ca60af6606d3252c74272b25"
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