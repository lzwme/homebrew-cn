class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.27.3.tar.gz"
  sha256 "f9a54d3a07dd9ac73813a7a5f1c3b59d1a970eb2ceb95a88929108ff1ddc8915"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b940d223e14145869535580cd8a22a4fdc1950cc21cf3231b62965ec8a18ae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b940d223e14145869535580cd8a22a4fdc1950cc21cf3231b62965ec8a18ae9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b940d223e14145869535580cd8a22a4fdc1950cc21cf3231b62965ec8a18ae9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b940d223e14145869535580cd8a22a4fdc1950cc21cf3231b62965ec8a18ae9"
    sha256 cellar: :any_skip_relocation, ventura:        "9b940d223e14145869535580cd8a22a4fdc1950cc21cf3231b62965ec8a18ae9"
    sha256 cellar: :any_skip_relocation, monterey:       "9b940d223e14145869535580cd8a22a4fdc1950cc21cf3231b62965ec8a18ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a46239ca1ebe8463b45284a9d600c937cd28582e441b13fdb9045417d25b532"
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