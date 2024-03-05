class Virtualfish < Formula
  include Language::Python::Virtualenv

  desc "Python virtual environment manager for the fish shell"
  homepage "https:virtualfish.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages542fa7800ae09a689843b62b3eb423d01a90175be5795b66ac675f6f45349ca9virtualfish-2.5.5.tar.gz"
  sha256 "6b654995f151af8fca62646d49a62b5bf646514250f1461df6d42147995a0db2"
  license "MIT"
  head "https:github.comjustinmayervirtualfish.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5c2508b685c079c55485e337f55aefc7b0e2798da055852e8ca1e9e5d3cbe59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f198267a8d05f8de7358c2f656482512746e0dc399be4df298317503ff1bd3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6514fdc780e83fd107afeba00b2b338adb2bc0de1d90a0a32093800bc8a66574"
    sha256 cellar: :any_skip_relocation, sonoma:         "13c993f381b13eed83af6481677af6479f690b538f1f219c7d8240e617916b4e"
    sha256 cellar: :any_skip_relocation, ventura:        "0e35d938523b626eb8708114f67f87000f73ed3ba9163ed3b0a4604f568b898e"
    sha256 cellar: :any_skip_relocation, monterey:       "7738a1c9f6fb42ea036b0b4ad3f1e494419d1bf2f1b9dc49ee0ac49928c5e510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7c4fa0bc5f4076a18ad84a490726b1a557af14d5ba2579cd66cc70b5e060bfd"
  end

  depends_on "fish"
  depends_on "python@3.12"

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pkgconfig" do
    url "https:files.pythonhosted.orgpackagesc4e0e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125epkgconfig-1.5.5.tar.gz"
    sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages90c76dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  # setuptools included due to https:github.comjustinmayervirtualfishissues240
  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages94d7adb787076e65dc99ef057e0118e25becf80dd05233ef4c86f07aa35f6492virtualenv-20.25.0.tar.gz"
    sha256 "bf51c0d9c7dd63ea8e44086fa1e4fb1093a31e963b86959257378aef020e1f1b"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To activate virtualfish, run the following in a fish shell:
        vf install
    EOS
  end

  test do
    # Pre-create .virtualenvs to avoid interactive prompt
    (testpath".virtualenvs").mkpath

    # Run `vf install` in the test environment, adds vf as function
    refute_path_exists testpath".configfishconf.dvirtualfish-loader.fish"
    assert_match "VirtualFish is now installed!", shell_output("fish -c '#{bin}vf install'")
    assert_path_exists testpath".configfishconf.dvirtualfish-loader.fish"

    # Add virtualenv to prompt so virtualfish doesn't link to prompt doc
    (testpath".configfishfunctionsfish_prompt.fish").write(<<~EOS)
      function fish_prompt --description 'Test prompt for virtualfish'
        echo -n -s (pwd) 'VIRTUAL_ENV=' (basename "$VIRTUAL_ENV") '>'
      end
    EOS

    # Create a virtualenv 'new_virtualenv'
    refute_path_exists testpath".virtualenvsnew_virtualenvpyvenv.cfg"
    system "fish", "-c", "vf new new_virtualenv"
    assert_path_exists testpath".virtualenvsnew_virtualenvpyvenv.cfg"

    # The virtualenv is listed
    assert_match "new_virtualenv", shell_output('fish -c "vf ls"')

    # Delete the virtualenv
    system "fish", "-c", "vf rm new_virtualenv"
    refute_path_exists testpath".virtualenvsnew_virtualenvpyvenv.cfg"
  end
end