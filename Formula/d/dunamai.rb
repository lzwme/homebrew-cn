class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https:github.commtkennerlydunamai"
  url "https:files.pythonhosted.orgpackages5e45a7ce37a6d6e0ae6d5ff4f6045e2b77a35233df2c786185c855f1a1edd427dunamai-1.23.2.tar.gz"
  sha256 "df71e6de961f715579252011f94982ca864f2120c195c15122f5fd6ad436682f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9582f32e94a7278b3ad55cec5407dd33c3d74b970b35f40d032c9d4a9a95e04e"
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