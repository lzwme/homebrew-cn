class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https:github.commtkennerlydunamai"
  url "https:files.pythonhosted.orgpackagesc2717cc5ba60aabefebfaa800e18d82388b0eb48f8f0becbfa5838afe7920484dunamai-1.21.2.tar.gz"
  sha256 "05827fb5f032f5596bfc944b23f613c147e676de118681f3bb1559533d8a65c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8d43035e422b5e3b5a8ccbbff0e23fafabbb79c30ae1dfc35b047b3d19701bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8d43035e422b5e3b5a8ccbbff0e23fafabbb79c30ae1dfc35b047b3d19701bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8d43035e422b5e3b5a8ccbbff0e23fafabbb79c30ae1dfc35b047b3d19701bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8d43035e422b5e3b5a8ccbbff0e23fafabbb79c30ae1dfc35b047b3d19701bc"
    sha256 cellar: :any_skip_relocation, ventura:        "d8d43035e422b5e3b5a8ccbbff0e23fafabbb79c30ae1dfc35b047b3d19701bc"
    sha256 cellar: :any_skip_relocation, monterey:       "d8d43035e422b5e3b5a8ccbbff0e23fafabbb79c30ae1dfc35b047b3d19701bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8b38674c183916edead477cf9c4fc4805d33d916f4669ba387339ed3b161d0b"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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