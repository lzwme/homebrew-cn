class NicotinePlus < Formula
  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https:nicotine-plus.org"
  url "https:files.pythonhosted.orgpackages70d515d8c60e3d27d3482fb8cba3ae0c49e57efe00f28e51b8aaea09f979bc48nicotine-plus-3.2.9.tar.gz"
  sha256 "41a86dc68b175d1dcac2ec2d79553cff4e5fbcca7f9f384c51cbaa393081b0c0"
  license "GPL-3.0-or-later"
  head "https:github.comnicotine-plusnicotine-plus.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0278cdcb03b270a7554386af39013a5261c4074c4e707027a0fcd4451fa1fccd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bc43fb01c74f583bcbf8c3f2a95a8f288822d18280c3044fafd8c11e32ed489"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d65e6d892d41983202678c4a3b4727c953bff0404a0fe39ced8cc4a67630632a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b3afc6cc64ba47d861e1a6ca816d7772b7ad58488701a9c23a82b80a6829f6c"
    sha256 cellar: :any_skip_relocation, ventura:        "4c5dcf9e3a43915859a934a6b595ded6635b29d96ead15d62f913f8b0f96b6f0"
    sha256 cellar: :any_skip_relocation, monterey:       "9bab9615e731475b5d0354206947096cd509895d6ff2a87a3dbd6eb367acb250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a35625dd14980819b3e368b908fbbd1fef28bddc60d7b844666e01e8e7ed98b1"
  end

  depends_on "python-setuptools" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-gdbm@3.12"
  depends_on "python@3.12"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nicotine -v")
    pid = fork do
      exec bin"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end