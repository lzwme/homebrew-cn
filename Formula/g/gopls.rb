class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https:github.comgolangtoolstreemastergopls"
  url "https:github.comgolangtoolsarchiverefstagsgoplsv0.15.0.tar.gz"
  sha256 "f44fd9dffb4564cd6e8a862d0925627f4d4fe9bab19453fb2d6161bc38ab2cd5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e434b5e73cca1721c1791672d17c33696a62877e6914da2b25a5f4d70c7a123b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f7b950c8ff2d938783eeda76c792528395879ed2ef7bd04210a79893d16b19c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13ed43691c656c534615818809f419057bee7c11e481f8ed9340ae1af40278e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bf0f3c706d034fe7f1ed0c01dc383520173a41d32b3da238650fff4aa98a4c6"
    sha256 cellar: :any_skip_relocation, ventura:        "618486b87c8baa8f5831c4f5177a5b72c1b8ea163bb75255c7b8dcb325bc4225"
    sha256 cellar: :any_skip_relocation, monterey:       "c34f4b3b83f900b9e86629768e41c14df54eea763a91f73fae04dca0677225f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "385e13d1efbb02c285e888174cbd0278ce3a54e9e279a79e2725c83274985d79"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end