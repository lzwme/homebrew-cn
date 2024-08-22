class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https:github.comashishbgabo"
  url "https:github.comashishbgaboarchiverefstagsv1.1.2.tar.gz"
  sha256 "2aba8f85f9d241217a56847c372f7d7a001218073f76f8e791bc161edd525611"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8759efedfe0dbf8ce146a936e7cfd9cdd55d7f97ff55b39fb133eb73e9d9d850"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8759efedfe0dbf8ce146a936e7cfd9cdd55d7f97ff55b39fb133eb73e9d9d850"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8759efedfe0dbf8ce146a936e7cfd9cdd55d7f97ff55b39fb133eb73e9d9d850"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c281c3251a06765ee26bad7de6452720dfc64443e66f635843575a2cac0bad0"
    sha256 cellar: :any_skip_relocation, ventura:        "1c281c3251a06765ee26bad7de6452720dfc64443e66f635843575a2cac0bad0"
    sha256 cellar: :any_skip_relocation, monterey:       "1c281c3251a06765ee26bad7de6452720dfc64443e66f635843575a2cac0bad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e8eb90c42fa05a03d5a69091f31b658083a1c139386d3050b2d5d1fb1d2e54b"
  end

  depends_on "go" => :build

  def install
    cd "srcgabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgabo"
    end
  end

  test do
    system bin"gabo", "--help"
    system bin"gabo", "--version"
    gabo_test = testpath"gabo-test"
    gabo_test.mkpath
    (gabo_test".git").mkpath # Emulate git
    system bin"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_predicate gabo_test".githubworkflowslint-yaml.yaml", :exist?
  end
end