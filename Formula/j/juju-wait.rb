class JujuWait < Formula
  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 3

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "303da078c86c9eaddd791ce344e0d6fbf9385b5ff4cffaa90ac910b8470266f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "268ed5860e7e913b45423248156bb5640ad73ed425caa9b69027379e4cb3e00d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea34e2bb1ec1f4142a84416b3f4e723169d39981029e356569aa039c9ed9ad18"
    sha256 cellar: :any_skip_relocation, sonoma:         "6db4290f87938fe4b43228106b87002ea963a3d29bb4abf0531e8ff6a2dd98e9"
    sha256 cellar: :any_skip_relocation, ventura:        "b0f5eaee9697c9314dc97c953123a2043cd06a3453fcf5a9a281898eeb9a2897"
    sha256 cellar: :any_skip_relocation, monterey:       "319541177a94f774de87ced218abdf4c69824bdcab6c21a0740bb19412f4ec99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0df86b91b3a8d26f0219243a6eccd28535bc82a39dc62df5ca5e4acf1c73380"
  end

  depends_on "juju"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    # NOTE: Testing this plugin requires a Juju environment that's in the
    # process of deploying big software. This plugin relies on those application
    # statuses to determine if an environment is completely deployed or not.
    system "#{bin}/juju-wait", "--version"
  end
end