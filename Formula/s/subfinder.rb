class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https:github.comprojectdiscoverysubfinder"
  url "https:github.comprojectdiscoverysubfinderarchiverefstagsv2.6.5.tar.gz"
  sha256 "acd9ccdbb9b5877cf3568ad299ce0a3445ccced09583280dfd881cffd20859f9"
  license "MIT"
  head "https:github.comprojectdiscoverysubfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20ae6be9a84567f39323a9e4db09b69bd842a2594588ee210d735e498a9b744a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b28e6f50d88cf7964d7861533ffe26bfd3c89cb12d36cbdbf289fbe4a0c1b8c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94fb052cca4ed64b4abe26e71a2e8d46bfe8b82a25a44b528cd5771e82311280"
    sha256 cellar: :any_skip_relocation, sonoma:         "24e830449af4d7eab551806759e2274c22c0f98ae5e3baa98e6060e185c7f4fc"
    sha256 cellar: :any_skip_relocation, ventura:        "d65444f86a04f53537fb2fe121e0af0d9581c334f9b8326ea68325c5ac033979"
    sha256 cellar: :any_skip_relocation, monterey:       "f6d80069c7001394d1c501359237b34b36d9eab566b22c9c05bf51d11b98ec30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5cd617596c29fc1719549b53fe246cfe16e99b672f9dd18b03a8b3a0ae05603"
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