class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://ghfast.top/https://github.com/guyfedwards/nom/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "c532172aec80dfdf673bff354a50811300853803c48a0729c1092a3b6bc5f060"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9ddefe8b2bbcef65d1f9d4505a9aefdeb41cb11eadecb838f6b2b2bc4ba9485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8964b651dd8f65b22277379f44d2848c03d084f8f8616edc100721a4fb7368e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0628289fcfdc4ba55e1d4efef572f207895a04f0568bab66322eae7d5954f05d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3acdc6551681f30a5e9512b293310a8988bad62143ef89b0f3dac8b2992cc438"
    sha256 cellar: :any_skip_relocation, ventura:       "22e3ed73f1033c4d3f843a242a61c79bd26db87100053d15823bffea94dbde78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b36aad32a42bbc4ccf248a6ca0b79b55e8bd7c1e833ad8b92e9c108b316a08a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2473504240a19d0bc00a105dfc86b7cbfcf9c33790da2e4dea29303a9b350b0a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end