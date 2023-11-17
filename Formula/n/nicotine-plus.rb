class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/70/d5/15d8c60e3d27d3482fb8cba3ae0c49e57efe00f28e51b8aaea09f979bc48/nicotine-plus-3.2.9.tar.gz"
  sha256 "41a86dc68b175d1dcac2ec2d79553cff4e5fbcca7f9f384c51cbaa393081b0c0"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64a3c9de5c69415b80b2356108628e5448d352155a14d3f997eecfd678ac4edd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02bca0b2770a44635bbd958622fe63f5cf2a8350d294cadacd14e8c822f100a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9d8ff92f3487e9d6e2c8b35c0a9ce1abc970a5fb389d63482ea00f599ab59a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fad5fc1f0302cfcbe1313f24937a2466a0cc366a97fd97111b899aa7de0d08f6"
    sha256 cellar: :any_skip_relocation, ventura:        "d2541e0ef599206ef3d7adbb827cb2ae3cf148fcbccc4ca31336b8df925ace02"
    sha256 cellar: :any_skip_relocation, monterey:       "4289833b8db2cb2a469e46c4569e761de09f6e6c034ff4604f47d209938c3d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e2181a4f34689217adab51c3ad6957d3766eed290561aac47d7fadd56084510"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-gdbm@3.12"
  depends_on "python@3.12"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end