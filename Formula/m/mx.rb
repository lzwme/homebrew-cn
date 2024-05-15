class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.25.3.tar.gz"
  sha256 "c3f347402759778dcd333ba981018a7852bdf43e42fb85305283f7626dc445b9"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27f343f37e7eb2a8370d216d86c6c8057a57ea4c60974168ce4a24f447b95251"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32aea8d0c43d2eb4da875d8454747ec1791df4bf2867473cebc4214e6be1e360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91fdbcd5c3a6ec06f16fe65b25e74b66ad3af2bc49a1348c8370aab86585ecf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "407db35a47e0d3e4795b2f8c1e6ce3e4d85fed94034ae52f6505c248971903a1"
    sha256 cellar: :any_skip_relocation, ventura:        "7c64890885142e9e98a925464069368cdb1d0ea02d937d9ef25cb4f3b2121c45"
    sha256 cellar: :any_skip_relocation, monterey:       "90eea6060383f0947c768388158abe803826fea98c0d659ffe943ddbfcfa53ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd69d91ac3ad75651e6d8aa5bf311a7ef31b0371e6b37e67661a4ffe23ecce6d"
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