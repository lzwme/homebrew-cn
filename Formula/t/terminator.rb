class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://ghproxy.com/https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "ba499365147f501ab12e495af14d5099aee0b378454b4764bd2e3bb6052b6394"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "052165795930397e5a73e38488a3c4e1dc8093c47d9e5b15cf89fbde85fcde78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9a457a8648e9c7854e507a0ff0c3fdb8556c97d7aba7d99c58bb8996ca5993c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed8774631ad42ddc984ef7740a5640863fdaa48f9f3e6fab2e8c60be130212f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9db11ee4db1c49a67cf236d6b8dc1e3a5431a131ecd1f95c29e3e564aa1135bf"
    sha256 cellar: :any_skip_relocation, ventura:        "f8b5279a4e1c1496fcbf930f823454aef287852c8bc2cb85a5df817cf812fa39"
    sha256 cellar: :any_skip_relocation, monterey:       "289a434c46d119b40e412ff507248fa84b622aeafa4018e17741107b878f6c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4a92242883f7649493fb09721cb1c336c09871ea7abeba66ad69627aa04785"
  end

  depends_on "pygobject3"
  depends_on "python@3.12"
  depends_on "six"
  depends_on "vte3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    pid = Process.spawn bin/"terminator", "-d", [:out, :err] => "#{testpath}/output"
    sleep 30
    Process.kill "TERM", pid
    output = if OS.mac?
      "Window::create_layout: Making a child of type: Terminal"
    else
      "You need to run terminator in an X environment. Make sure $DISPLAY is properly set"
    end
    assert_match output, File.read("#{testpath}/output")
  ensure
    Process.kill "KILL", pid
  end
end