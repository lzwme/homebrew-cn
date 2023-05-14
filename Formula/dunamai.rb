class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/57/f8/5d45804589d3ebeaa259ac8a5d623afcd5d411b7909edf3f03bb0f7c43dd/dunamai-1.16.1.tar.gz"
  sha256 "4f3bc2c5b0f9d83fa9c90b943100273bb087167c90a0519ac66e9e2e0d2a8210"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dcadbaa28d94a2d540668261dfbc850417acc8c26e118508e9dc06ea79a1f67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e5b6d8bb7802d5bd9d7c5e114928d64b08bf2dba57cb0fedfbe7b34043449bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc3fc88e9e207f4d342ef74d6c31bee24981049963487a1b3c1dc0eb9ac7776d"
    sha256 cellar: :any_skip_relocation, ventura:        "681029834e2879902cc6d4d2af9d374aa111b92a1cf796124fcd4896fa9551c9"
    sha256 cellar: :any_skip_relocation, monterey:       "30f2e57bfeac493a87f0ccd6071caa832eb5b7ccc97c1ea4ab071af84c2c9adb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a4573631255954d09fca3c9bcf3117d61ec5a7eba4034a3e4ed162f06f7ee9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6546a822d7adecd6f1b7a0ac48f39cf87f6dc373fa26d76a1eee57569560bc23"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end