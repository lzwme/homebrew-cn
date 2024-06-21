class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.27.2.tar.gz"
  sha256 "c768845a5faf3741625f58969e3a1ca889e3fb32806c731c4d09f2ed50b3bf39"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a089376e2990ddd9b0a3c0bf27021e9d0bfbaa4822923b1651a3505cf0b5d0d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a089376e2990ddd9b0a3c0bf27021e9d0bfbaa4822923b1651a3505cf0b5d0d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a089376e2990ddd9b0a3c0bf27021e9d0bfbaa4822923b1651a3505cf0b5d0d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a089376e2990ddd9b0a3c0bf27021e9d0bfbaa4822923b1651a3505cf0b5d0d1"
    sha256 cellar: :any_skip_relocation, ventura:        "a089376e2990ddd9b0a3c0bf27021e9d0bfbaa4822923b1651a3505cf0b5d0d1"
    sha256 cellar: :any_skip_relocation, monterey:       "a089376e2990ddd9b0a3c0bf27021e9d0bfbaa4822923b1651a3505cf0b5d0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164330556a6841e7f540084d1f218ef1eff9d7c4b6a55d014df163be08e3f634"
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