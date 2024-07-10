class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.27.6.tar.gz"
  sha256 "90367f63f4e0cc41cb3c3a923b817282c51596862534a78c320b752550f74c5b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca15fe1739145765521269f0464563fea334900041d1cfb5a5a9280bc3fcf57c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca15fe1739145765521269f0464563fea334900041d1cfb5a5a9280bc3fcf57c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca15fe1739145765521269f0464563fea334900041d1cfb5a5a9280bc3fcf57c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca15fe1739145765521269f0464563fea334900041d1cfb5a5a9280bc3fcf57c"
    sha256 cellar: :any_skip_relocation, ventura:        "ca15fe1739145765521269f0464563fea334900041d1cfb5a5a9280bc3fcf57c"
    sha256 cellar: :any_skip_relocation, monterey:       "ca15fe1739145765521269f0464563fea334900041d1cfb5a5a9280bc3fcf57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baec46d0cdc442ff3a6bbe5689f898725bf9ced7d96d8a6274568c9a5ac1fd67"
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