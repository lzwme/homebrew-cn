class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.25.5.tar.gz"
  sha256 "6302c90f5299cf9884dead5faca62a76e15d47be200f609bbea9c5f06d895864"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff28213c301ed694f2b0715f2c5d0f7d06e2bc2496689102b2b00b1be7f56505"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdee1107e673f07b46138e57025fec0005c930150f0ea475ff770b9f025d9b6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "affa5d0ac3aea50af0603bbf046f1ee4ad481f1f1696fd69d01a376808203063"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff2bc51c49347b728821fce163f99192712b88513586bb9caea7877a8e52bea0"
    sha256 cellar: :any_skip_relocation, ventura:        "be8ed2cecf8239b5a1572446dc45ebc6fbbd7022012190de35abc7f84f46b909"
    sha256 cellar: :any_skip_relocation, monterey:       "c61560467ca2754c22adb37f42e4846c94dbfd0a42f919fa54bced6d46baa432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c14254295a40c2a9af866d86c81f43f6c94fba54940cd5d64cdaf92ee5a71784"
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