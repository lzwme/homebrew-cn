class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.25.2.tar.gz"
  sha256 "c683b8473e50151fb899d5f39ac8dffe2d9f7711130b1f4a3f3dac52e4ed1aa4"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c64053e60334a14e6915d3349105791e5f5f75d4126010d7da9ae8bfa4173081"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd175851fb647c68ad76382e35096469d13a102bf78d1f670591ba6f3f2905b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18471b3fe2d1d0fb24e60fd1c1320f451062aa9bada4edebac170f7289585556"
    sha256 cellar: :any_skip_relocation, sonoma:         "710ee4a9841261d0b10c8745a22e98ea08d3c1952dc9714a7bc12b258fc13a53"
    sha256 cellar: :any_skip_relocation, ventura:        "a810c9a12c72932def0e15ae7802e0675964c53f4c5812d92976874a415be892"
    sha256 cellar: :any_skip_relocation, monterey:       "1a47f7d17f9b4575d1a942a3a4a152d03de3bf13c614d2062f32b06cf3684219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "580d3fa819a27b3c546a8822ae40f2130a0b108f3e79545dae503ab053c83a70"
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