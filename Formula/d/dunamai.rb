class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https:github.commtkennerlydunamai"
  url "https:files.pythonhosted.orgpackages7b391d9099f7529c61c80ef00c88b385493b9f6183582ac9bca5af84fe62311bdunamai-1.24.0.tar.gz"
  sha256 "c2d1a9f7359033c04dfc1865481d890acc5be4ac02596ad3275b854aba342294"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6dd7ec71034e04dba5dc663ed3a4c445124baf7e0277be99c8d72426cc02a268"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
    assert_equal "0.1", shell_output("#{bin}dunamai from any").chomp
  end
end