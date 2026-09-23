class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/15/98/64a9e67f5917396f5165861f7860690d0192dc3b392a70db00274d3d961a/adb_enhanced-2.12.0.tar.gz"
  sha256 "d477de8246c27e0308eeee952a5768a5844ff5c8a027d62ea40fbeb9e57e3ab4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bfd1e557448e788ff7d0c04faf874ea7ceb743ebbe81a940ef16938842f84bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe9448f2254b46252259210bd0ec62f8b845bfdc96f1b138886097ca91865758"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0e582eff03588c63ca9d8553eb4d1904f4315e25bcd9aa170fa51e990336c30"
    sha256 cellar: :any,                 arm64_linux:       "1797202002980fd7de28e1101643b1570a3aa2fcafd5e2119390cb03edf93393"
    sha256 cellar: :any,                 x86_64_linux:      "1e345062061e2a5fbd25003d8b727709e208aa12ccb62c722722ba8e597c4106"
  end

  depends_on "python@3.14"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  # Although the virtualenv_install_with_resources uses the package resources listed above,
  # pip still needs to fetch the project's chosen build system via the network.
  deny_network_access! [:postinstall, :test]

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end