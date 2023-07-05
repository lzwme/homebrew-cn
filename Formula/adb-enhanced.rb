class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/0b/87/b1375ade9b02c67d4a8fe760d9d8cc4250c37e1db19d0ba1343a3bc79d9c/adb-enhanced-2.5.21.tar.gz"
  sha256 "976db27d1334782965592d7cd2202d4de803eecb1360f2c710ad07dcc2af3539"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f38d15411c5ad59b5de031c4560f6f1e84236e304a68285f23561b4f20800af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7742cf36049fee56e182fcb4fb49d53511f793fcc9cc6ff612eb86009256bf37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b54b0e7487a425bc19a52e0647288e7ead6b4ae19afd5b531ca89ee585507865"
    sha256 cellar: :any_skip_relocation, ventura:        "0327734f4e7f3366723a9438ef8c5c567ecb2d312ecb17f8d83f99ab574ed045"
    sha256 cellar: :any_skip_relocation, monterey:       "ff96759ae1e33b4228ded4a95ea8f4e8cbfbefe94bce5b42a001a9f9bc6024bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1212b6a4d6c7e2d2caf7e372f0d5d3701d1f376f984cb9990db407e0ac93cf5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "977aac2bed3a019b3a6ce71fec3479531870b3a965dbc3460eb4cacee6e67191"
  end

  depends_on "python@3.11"

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