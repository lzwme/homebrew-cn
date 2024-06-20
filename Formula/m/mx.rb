class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.27.1.tar.gz"
  sha256 "71779b0283895da619bb7e0394385fc85e03ca100b49f8b8db3b71e013288774"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccf8310fc4cf4f23c75dc346a33264f5cfe4643e82e08bc085401d25a23a336e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccf8310fc4cf4f23c75dc346a33264f5cfe4643e82e08bc085401d25a23a336e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccf8310fc4cf4f23c75dc346a33264f5cfe4643e82e08bc085401d25a23a336e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccf8310fc4cf4f23c75dc346a33264f5cfe4643e82e08bc085401d25a23a336e"
    sha256 cellar: :any_skip_relocation, ventura:        "ccf8310fc4cf4f23c75dc346a33264f5cfe4643e82e08bc085401d25a23a336e"
    sha256 cellar: :any_skip_relocation, monterey:       "ccf8310fc4cf4f23c75dc346a33264f5cfe4643e82e08bc085401d25a23a336e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74fce9093579e6967d096f4b9597402af3d0e8ce6a0bc51e9897efa069d6c526"
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