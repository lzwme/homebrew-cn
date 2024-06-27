class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https:github.comgraalvmmx"
  url "https:github.comgraalvmmxarchiverefstags7.27.4.tar.gz"
  sha256 "af9e2f68ba0ee7132f369b3242f8bbf5410e6c213b550e7c1d18a8f4858a01c0"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b5893e3f1c780a36b8398b59b5f4e4afe31bc82e4a3e89879622ae6d18f48e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b5893e3f1c780a36b8398b59b5f4e4afe31bc82e4a3e89879622ae6d18f48e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b5893e3f1c780a36b8398b59b5f4e4afe31bc82e4a3e89879622ae6d18f48e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b5893e3f1c780a36b8398b59b5f4e4afe31bc82e4a3e89879622ae6d18f48e7"
    sha256 cellar: :any_skip_relocation, ventura:        "8b5893e3f1c780a36b8398b59b5f4e4afe31bc82e4a3e89879622ae6d18f48e7"
    sha256 cellar: :any_skip_relocation, monterey:       "8b5893e3f1c780a36b8398b59b5f4e4afe31bc82e4a3e89879622ae6d18f48e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6428e457055abd374957efa23cbf0fb76664722a9bcad91997a6d488e99579a"
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