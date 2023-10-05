class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/82/11/1228620ea0c9204d6d908d8485005141ab3d71d3db71a152080439fa927d/adb-enhanced-2.5.22.tar.gz"
  sha256 "b829dcb4c9a9422735d416a62820de679bed8b08dfbff2014d46a525c39bc7d0"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35a349686e3d2164c7e8670a5ba766aaf5033e238e6c4014b80d67cae5ec4af4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3692fd1971e2b1c5071799c018093cdb61dd82ee283164c288dc863073f963f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1ed282fe0dc7099e52291140989b0d89d2672f1b1059faf13196c7c6455e9cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bdce11bbb1ffdb458f8003326aa02100df9877671faea33c22c0a1fd490c321"
    sha256 cellar: :any_skip_relocation, ventura:        "eaf7bcb836fa4b9238a86aacee12b889b550602e924cafda1a0dba63025d595b"
    sha256 cellar: :any_skip_relocation, monterey:       "bdb9fb28d912d89cdb0f6b519bfd416c8ad5cf806d5e2af2bb78a1e043b27cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76054a79869e3dd04d2f3b9d12b513fc07665d00994bc481ffa42c9402a4b6e4"
  end

  depends_on "python@3.12"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match "not found", shell_output("#{bin}/adbe devices", 1)
  end
end