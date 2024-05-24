class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.25.7.tar.gz"
  sha256 "c25767811f5f6f59ddd82221a4b22120f12edcce0ece4c69d02f17b0a14a1d6b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d938302ea9b2488694bf177fc4bbb5548f4f6e994d898fe2b452cddbeb595437"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e11ddb1c5bae7397ecaadc0160b94d992b8cf4c4f870553f88176001ee93aa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf6a774abe75e7ed7ebce2700022ff1337f86c8c9c690c9f9554dc5af63f4e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e3f9b88c49b303ef249c7858d02990299a47457ff99d5bb9f2ca2d6e80cf892"
    sha256 cellar: :any_skip_relocation, ventura:        "ee785e99f194c36d7c56c7c0631b811b0c4a884291ab811b8c9d24f243b99c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "086a92cb50c38a3f553ca8c8a8e9a91e560fc91d48508157c406b4a7021cf96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0033fa21a07f379e08b75eb78aac189125e6953d3946f3f33f153eb60d94773"
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