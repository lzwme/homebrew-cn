class SpoofMac < Formula
  include Language::Python::Virtualenv

  desc "Spoof your MAC address in macOS"
  homepage "https:github.comferossSpoofMAC"
  url "https:files.pythonhosted.orgpackages9c59cc52a4c5d97b01fac7ff048353f8dc96f217eadc79022f78455e85144028SpoofMAC-2.1.1.tar.gz"
  sha256 "48426efe033a148534e1d4dc224c4f1b1d22299c286df963c0b56ade4c7dc297"
  license "MIT"
  revision 4
  head "https:github.comferossSpoofMAC.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc23f4b6fa3467c6298a47f858febe91146b18f4018cb7f8c4be4dd9e0cae4b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "857ddfdc585bddb1acc7e7739f97175019ee81a42208d223d922fe71ac4b0b53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23259206226a3e5414299b25a604284441847752961649ef13310497ae09b80b"
    sha256 cellar: :any_skip_relocation, sonoma:         "08dca80a74ba27396c9acefa9265c2c31fe85b2825e12f06d9a762d448544208"
    sha256 cellar: :any_skip_relocation, ventura:        "582558220e69af10f2d2f6a760d91c340a977835462d470a2dd7a6fd99c042fd"
    sha256 cellar: :any_skip_relocation, monterey:       "67e7232a92830bae44554923be676dd99e14ead0db1e1c2554fbc951e13f0e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c9f080491e0618def5995daf982499bec4f7cd01904243b27d43978b1d71af5"
  end

  depends_on "python@3.12"

  on_linux do
    depends_on "net-tools"
  end

  resource "docopt" do
    url "https:files.pythonhosted.orgpackagesa2558f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Although spoof-mac can run without root, you must be root to change the MAC.

      The launchdaemon is set to randomize en0.
      You can find the interfaces available by running:
          "spoof-mac list"

      If you wish to change interface randomized at startup change the plist line:
          <string>en0<string>
      to e.g.:
          <string>en1<string>
    EOS
  end

  service do
    run [opt_bin"spoof-mac", "randomize", "en0"]
    require_root true
    log_path "devnull"
    error_log_path "devnull"
  end

  test do
    system "#{bin}spoof-mac", "list", "--wifi"
  end
end