class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.27.5.tar.gz"
  sha256 "1721c672b0afe66c0466393aa6b31286f199e8dd217950364350f8098d1b7531"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "449cfbea0437f75eac2cbac75ae34e3c6da86963ff3f1205b03ff0eeb0496386"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "449cfbea0437f75eac2cbac75ae34e3c6da86963ff3f1205b03ff0eeb0496386"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "449cfbea0437f75eac2cbac75ae34e3c6da86963ff3f1205b03ff0eeb0496386"
    sha256 cellar: :any_skip_relocation, sonoma:         "449cfbea0437f75eac2cbac75ae34e3c6da86963ff3f1205b03ff0eeb0496386"
    sha256 cellar: :any_skip_relocation, ventura:        "449cfbea0437f75eac2cbac75ae34e3c6da86963ff3f1205b03ff0eeb0496386"
    sha256 cellar: :any_skip_relocation, monterey:       "449cfbea0437f75eac2cbac75ae34e3c6da86963ff3f1205b03ff0eeb0496386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4c57e77273e6707712d97c0b2389eec7e391d3c8a7dfafcc002131e9ae870fb"
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