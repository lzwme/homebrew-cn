class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https:github.comwusthoepr"
  url "https:files.pythonhosted.orgpackages3920d647083aa86ec9da89b4f04b62dd6942aabb77528fd2efe018ff1cd145d2epr-reader-2.4.15.tar.gz"
  sha256 "a5cd0fbab946c9a949a18d0cb48a5255b47e8efd08ddb804921aaaf0caa781cc"
  license "MIT"
  head "https:github.comwusthoepr.git", branch: "master"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, all: "365cb8927fc2d6153f76442b55a3733ac91cbe8aa1fb6d6646b4659a3a2b9f95"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}epr -r")
  end
end