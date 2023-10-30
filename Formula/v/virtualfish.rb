class Virtualfish < Formula
  include Language::Python::Virtualenv

  desc "Python virtual environment manager for the fish shell"
  homepage "https://virtualfish.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/54/2f/a7800ae09a689843b62b3eb423d01a90175be5795b66ac675f6f45349ca9/virtualfish-2.5.5.tar.gz"
  sha256 "6b654995f151af8fca62646d49a62b5bf646514250f1461df6d42147995a0db2"
  license "MIT"
  head "https://github.com/justinmayer/virtualfish.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f247a3d61821e4b5b0cc1ede4f39c4c698037a6490816229a9a770b341fc902"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f86626ae92fe1c934fe678be8fd4fb5835c8696e8bc4a56d5be413fe8418e806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d95595eca51362b908d0a2d2f51c4fd14df93bc1520000e84a7fece52badd769"
    sha256 cellar: :any_skip_relocation, sonoma:         "51af3c2433d0d84776e468f95179695a0b1dd9d10530b53892ed5237b1a5769b"
    sha256 cellar: :any_skip_relocation, ventura:        "4b7198e35a518a0f45eb70a04429deddd63e5281246283ba0d4a7dcdb29cc1f3"
    sha256 cellar: :any_skip_relocation, monterey:       "7f569f4c0a255980b8245b59204ac037e3bae382b387dbfeddb11c8152f715be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d02d694ebc0f8363cb640d3493f18a44b23c2399110db2db09c8111070e34028"
  end

  depends_on "fish"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/c4/e0/e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125e/pkgconfig-1.5.5.tar.gz"
    sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  def caveats
    <<~EOS
      To activate virtualfish, run the following in a fish shell:
        vf install
    EOS
  end

  test do
    # Pre-create .virtualenvs to avoid interactive prompt
    (testpath/".virtualenvs").mkpath

    # Run `vf install` in the test environment, adds vf as function
    refute_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"
    assert_match "VirtualFish is now installed!", shell_output("fish -c '#{bin}/vf install'")
    assert_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"

    # Add virtualenv to prompt so virtualfish doesn't link to prompt doc
    (testpath/".config/fish/functions/fish_prompt.fish").write(<<~EOS)
      function fish_prompt --description 'Test prompt for virtualfish'
        echo -n -s (pwd) 'VIRTUAL_ENV=' (basename "$VIRTUAL_ENV") '>'
      end
    EOS

    # Create a virtualenv 'new_virtualenv'
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
    system "fish", "-c", "vf new new_virtualenv"
    assert_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"

    # The virtualenv is listed
    assert_match "new_virtualenv", shell_output('fish -c "vf ls"')

    # Delete the virtualenv
    system "fish", "-c", "vf rm new_virtualenv"
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
  end
end