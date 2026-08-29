class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/4d/b7/1db48a9ce2984842c8c886432ec8a2719613322e868a966ba82a28862f25/build-1.6.0.tar.gz"
  sha256 "bd2c8afc603e7a2e0ce70e2ea85f0a6d02043bafbd307f5bada0f98669eca5af"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6b03432b1352bf4f852210ca28000f01f7f1187b49b363546e5bc1a68f248b7"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    stable.stage do
      system bin/"pyproject-build"
      assert_path_exists Pathname.pwd/"dist/build-#{stable.version}.tar.gz"
      assert_path_exists Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl"
    end
  end
end