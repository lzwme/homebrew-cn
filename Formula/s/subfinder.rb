class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https:github.comprojectdiscoverysubfinder"
  url "https:github.comprojectdiscoverysubfinderarchiverefstagsv2.6.7.tar.gz"
  sha256 "3ce0d4ddcca869d459a2571a2c1b437456007109e5d6ebfc4d3fdcea6a6edca7"
  license "MIT"
  head "https:github.comprojectdiscoverysubfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5b5ca72a00538c53851f4774df4d0c4b6833a152acf799914d0b9075e625c26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631abc68d4d6b6fa26bb443a7a85a9353aef4349839889ea8b575c6b4688440b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c6c9a8ec2ca27e609e889f60c9adc2a4963c3674231dc6ef3b7876de3acdb5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d68e7558315685362d262cefaa0d4e98706f0088dc533083ab7d51698e8b083b"
    sha256 cellar: :any_skip_relocation, ventura:       "e392586f300d94c62c1ca1fda6ef503140571c152f2773085bd4bdf031181220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7f1ec01d8d7a1b169ee715bbd106a799c7c93b8bf8d41869c05f278844b9f8"
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