class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/cf/76/54e0964e2974becb673baca69417b6c6293e930d4ebcf2a2a68c1fe9704a/bpython-0.24.tar.gz"
  sha256 "98736ffd7a8c48fd2bfb53d898a475f4241bde0b672125706af04d9d08fd3dbd"
  license "MIT"
  revision 1
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd5c5c19ada447d20da042dc4f47193e61c974622b42c1929ae8b80898393567"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed20df4af72a6ac636dd8a6e39b2de6089cd75982c989df62fb07d95811fb7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a44ce47a1f8f2127da333cca9d3538693b3046085deeb9ee1ef15ac42a5fcb6"
    sha256 cellar: :any_skip_relocation, ventura:        "a319ae7ff5c84d37b7c73cfc644a2e5e0824e65838b23f28b3bd6a7168fdc5e7"
    sha256 cellar: :any_skip_relocation, monterey:       "1ee8444ed309fb137baf6f17bfade0f07a763e0552ef261e18f2a73c462dfb73"
    sha256 cellar: :any_skip_relocation, big_sur:        "2168421be4127be211ce8cbcca7bec24df8ff2bf76228fd0a736bc1905084d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12ee3a84865eb60acd7685237122df35f8e24636684c5ffd31d8d33428ca9d2f"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/4e/43/838c06297741002403835436bba88c38d0a42ed9ce3e39a61de73e4cb4d0/curtsies-0.4.1.tar.gz"
    sha256 "62d10f349c553845306556a7f2663ce96b098d8c5bbc40daec7a6eedde1622b0"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/c6/6c/fe4a10bd3de2a3ecdcb53e8ad90ec9fddc846342e5e39e6446c692637414/cwcwidth-0.1.8.tar.gz"
    sha256 "5adc034b7c90e6a8586bd046bcbf6004e35e16b0d7e31de395513a50d729bbf6"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/1e/1e/632e55a04d732c8184201238d911207682b119c35cecbb9a573a6c566731/greenlet-2.0.2.tar.gz"
    sha256 "e7c8dc13af7db097bed64a051d2dd49e9f0af495c26995c00a9ee842690d34c0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # Make the Homebrew site-packages available in the interpreter environment
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/site_packages
    ENV.prepend_path "PYTHONPATH", libexec/site_packages
    combined_pythonpath = ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH"
    %w[bpdb bpython].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin/#{cmd}", PYTHONPATH: combined_pythonpath
    end
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end