class RbenvChefdk < Formula
  desc "Treat ChefDK as another version in rbenv"
  homepage "https:github.comdocwhatrbenv-chefdk"
  url "https:github.comdocwhatrbenv-chefdkarchiverefstagsv1.0.0.tar.gz"
  sha256 "79b48257f1a24085a680da18803ba6a94a1dd0cb25bd390629006a5fb67f3b69"
  license "MIT"
  revision 1
  head "https:github.comdocwhatrbenv-chefdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43558c05b45ae34900651355579bbcac63771e75f98c501059233f4f1d832d5f"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "rbenv-chefdk.bash", shell_output("rbenv hooks exec")
    assert_match "rbenv-chefdk.bash", shell_output("rbenv hooks rehash")
    assert_match "rbenv-chefdk.bash", shell_output("rbenv hooks which")
  end
end