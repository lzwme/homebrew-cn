class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https:github.comprojectdiscoverysubfinder"
  url "https:github.comprojectdiscoverysubfinderarchiverefstagsv2.6.4.tar.gz"
  sha256 "8e491c31ba1bba8d9e5dfd0c6f8ebf4ffb078db97b2be42a4ba39841fddecaf9"
  license "MIT"
  head "https:github.comprojectdiscoverysubfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6509df6490bc3813fdae57073331f3bd85e6322a8d81a609ee231b7d8093cca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f00b47b6108ab3737e5333ddf32ecba1b64e47dccea4007de246f872abb225f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71eaf7d538b4d2b1bc81ada58415675ad98c9a57e07786f15812a72c7cdb2532"
    sha256 cellar: :any_skip_relocation, sonoma:         "d781920c0563cc0ab143bab130f203f0838ee94fa1b6eb7744347f1e683ca7db"
    sha256 cellar: :any_skip_relocation, ventura:        "3c02b9210033b042ced8029bc7a6f16da1b80fef5bd6d74093c1b6f5d9b09663"
    sha256 cellar: :any_skip_relocation, monterey:       "a3b7b74c06a1ec0dd8e8a57628318a85a1b7ec0ba83102713fcbbb31123dd68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "628cddc04191d539fb9997347c7e2ad7e869272fc6ed90f7f57f05d1067313ac"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdsubfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}subfinder -d brew.sh")

    # upstream issue, https:github.comprojectdiscoverysubfinderissues1124
    if OS.mac?
      assert_predicate testpath"LibraryApplication Supportsubfinderconfig.yaml", :exist?
      assert_predicate testpath"LibraryApplication Supportsubfinderprovider-config.yaml", :exist?
    else
      assert_predicate testpath".configsubfinderconfig.yaml", :exist?
      assert_predicate testpath".configsubfinderprovider-config.yaml", :exist?
    end

    assert_match version.to_s, shell_output("#{bin}subfinder -version 2>&1")
  end
end