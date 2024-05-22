class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.25.4.tar.gz"
  sha256 "fae0db4b01eadb6236dc65f17fa8ce0cc11824932db04975819dc8b3de3c29ec"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfcb79a2afac42b920a95a0cb19014865287a5e9f8e8bf03e8534a52a37b8f4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e3dab20fbd06629b2f6a5d66738f5574966e4814a77fa208793954e9d509f30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08f7ee2fad92e89168c53c853c9c3b32c68cae0cbb2da8b5c6ade5fd9400b0fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "4da0acd35f1978a0a9640e3d1619954e3d49fc7a625a9a3fdaa6e34471bed4c3"
    sha256 cellar: :any_skip_relocation, ventura:        "a16639f38ffc942d503468c7d88957c34feba1a847d83a01032e9e3fa0756011"
    sha256 cellar: :any_skip_relocation, monterey:       "47f59481dfd948511b8437bef44fa4e6cf41de57375474a098b5c80d03b79408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f176b792e8593cf2f452401bcf3b525598c74ab7d141bd7dd2a2a3678e42e3a"
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