class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https:github.comAmrDeveloperGQL"
  url "https:github.comAmrDeveloperGQLarchiverefstags0.27.0.tar.gz"
  sha256 "df90f110ea012498132d6e809c191fdbdf6838eec01be96f6d1270b9e5267b5b"
  license "MIT"
  head "https:github.comAmrDeveloperGQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d87cf5a15e277e67b8db8a0593b35a264b3b360f70dc76e6f0ba5a67bd80d8d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a9b494c1a877123bb9a4d44591b08235b43933afcbb0b699a51e41a21c02249"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "999f0b88da6cf2cbb770c8fd7900592cef5b64672280a9b11309a3ee28899858"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "238e92f8c605b9d0f9d97dbda6eb2a33901dd1eab560394624387ea1f163c271"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a93447561476ba39fcc43f3ab897cb25ee4c538774b2779d65306a943b41690"
    sha256 cellar: :any_skip_relocation, ventura:        "1685913d26e84db497b04bfdde05325fb58f5a4b83560cabb41e23b8800a223c"
    sha256 cellar: :any_skip_relocation, monterey:       "c3bf0afcf3d971c1ee2ea888101fc200e1609dd9b54656029bd0396f601af0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da12509439690345b981761c5071a3df8f531b2096a667b5cc05ff80de42644"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_1"]
  end
end