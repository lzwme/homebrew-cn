class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https:github.compypabuild"
  url "https:files.pythonhosted.orgpackages7d46aeab111f8e06793e4f0e421fcad593d547fb8313b50990f31681ee2fb1adbuild-1.2.2.post1.tar.gz"
  sha256 "b36993e92ca9375a219c99e606a122ff365a760a2d4bba0caa09bd5278b608b7"
  license "MIT"
  head "https:github.compypabuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "baa2258647a8db4193958fe089d8cc79042cf02f2465eb1e22695356d3ecbc13"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackagese78228175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  def install
    virtualenv_install_with_resources

    # Ensure uniform bottles by replacing a `usrlocal` reference in a comment.
    inreplace libexec"libpython3.12site-packagesbuildenv.py", "usrlocal", HOMEBREW_PREFIX
  end

  test do
    stable.stage do
      system bin"pyproject-build"
      assert_predicate Pathname.pwd"distbuild-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd"distbuild-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end