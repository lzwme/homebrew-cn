class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://ghfast.top/https://github.com/alecthomas/chroma/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "5bae5544762e9c58d1a6eb7b04248576859d866855561e82226020a8dda606a7"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40aaa2bac5464cc251c07592c361ff73ef22f768f0f0279df8e7b2000e8e418e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40aaa2bac5464cc251c07592c361ff73ef22f768f0f0279df8e7b2000e8e418e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40aaa2bac5464cc251c07592c361ff73ef22f768f0f0279df8e7b2000e8e418e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b9a27cfc42f7ca5483eec6555deb5706a531aa8b227abecaa8943bec99fcc48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e9734eaa72c640e3140dc89d7d60f1610d61714e2cfd0431d484c96a1bab1e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bf42baa80131271f2579eb7fb724fdb4d0cc4493ef735c2d914e27a73699537"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end