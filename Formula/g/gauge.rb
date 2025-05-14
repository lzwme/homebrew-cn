class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https:gauge.org"
  url "https:github.comgetgaugegaugearchiverefstagsv1.6.15.tar.gz"
  sha256 "19cb937635bbc260452b1ab7979d017c5dab7f483f465f43cac24509057b3ee5"
  license "Apache-2.0"
  head "https:github.comgetgaugegauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aaddc6d88c42f1a9610c326795a6ca6d3a9b767657e4c85dbcd9b8317c6cb2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ebf9f59fc33da5d8af6c792f9dba342c014426ab669cbaa8f213d615e04ecd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68ad4df098c28c71640762b85e52531a39402f0aeb92b26b2e1629cdf77d12a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "868c8a1ec76518606b0a00c244283b83011e3a02b1767b7ae61219fe41da2641"
    sha256 cellar: :any_skip_relocation, ventura:       "a8e81e7d54e7b55f785237a3f0c19c7314b3646ddadf77331d14257adf5b33e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58654b2af8e69d38597ea641a0ac98405f7ad37ebc3c1b6213e074026ec3908"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "buildmake.go"
    system "go", "run", "buildmake.go", "--install", "--prefix", prefix
  end

  test do
    (testpath"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin"gauge", "install")
    assert_path_exists testpath".gaugeplugins"

    system(bin"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}gauge -v 2>&1")
  end
end