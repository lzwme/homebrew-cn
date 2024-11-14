class Ydiff < Formula
  include Language::Python::Virtualenv

  desc "View colored diff with side by side and auto pager support"
  homepage "https:github.comymattwydiff"
  url "https:files.pythonhosted.orgpackagesccc082cb70f5e1042ec7989288e82ba43dde6809d65a31b5da81912b8c3456a1ydiff-1.4.1.tar.gz"
  sha256 "28c99b4c109e5a9870c42f24b7a357419f2c1919335d9e8be1324eb7ae82c6f9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a18c9c49c4a25b326deca039b8a23a1d27926cbca568a56bfc6840a685f5f73"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}ydiff -cnever", diff_fixture)
  end
end