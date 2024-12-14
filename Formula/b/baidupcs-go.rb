class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https:github.comqjfoidnhBaiduPCS-Go"
  url "https:github.comqjfoidnhBaiduPCS-Goarchiverefstagsv3.9.6.tar.gz"
  sha256 "d6fadb9ed5ef28d0a64123f1c12855ad19c5cd44df67a844dc654fa3bdd2fc0b"
  license "Apache-2.0"
  head "https:github.comqjfoidnhBaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd0e5a6c28b520368b1bce34e532cea1915a408f50cc4d8ac9c2ad5ec178230a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d9926380f7f8c1348a8d4cebc4ceb55e1e996aab49fbe0b0d9e805fd707a417"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6954c64d6e5a3c3463c88ccb523d0a6a9975b8c78d67147b8d3a98174fda5b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "23d668b529dd367a9c7fc2bfd823a1eba81ce18b921c10376e963400787a52e8"
    sha256 cellar: :any_skip_relocation, ventura:       "3e6e22890eb8407d53510d18a05a6c41aa9754f46ce456044d81b8964fb8900c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb643c2966d45e3c056d1029c390376df7ad795b231b6a2c61e343772ab9dbbf"
  end

  # use "go" again when https:github.comqjfoidnhBaiduPCS-Goissues336 is resolved and released
  depends_on "go@1.22" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath"test.txt", :exist?
  end
end