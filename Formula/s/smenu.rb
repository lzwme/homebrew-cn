class Smenu < Formula
  desc "Powerful and versatile CLI selection tool for interactive or scripting use"
  homepage "https:github.comp-gensmenu"
  url "https:github.comp-gensmenureleasesdownloadv1.4.0smenu-1.4.0.tar.bz2"
  sha256 "9b4e0d8864746175c1b20d75f5411fa013abdaf24af6801f1c5549b6698e195b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0db2b3c8020378b8c8a1391a13ddb5be2a628c4c4972e7cad5aa4e000afc25f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6850bd70569c2cd871520c8eb5738a5d3d4f4be1d1a0358bdde55c79e7372c39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "884d6e69189dced3348d6dbb74c7c5cc133744bd2515afa983b8247831055ef2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d24ecc393322fe0071e5a3ae8d8955193d48b0087708e6c7644fa818ae9349"
    sha256 cellar: :any_skip_relocation, ventura:       "af00f9aa936f24a34a6b244c215f817e35d983c2be1f506905aa97ed3f021528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3db6f36d33d8abe889bd624b2ce8fbad7e91a4f110fb1ed929849dcb198a759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "149396da00c29749fd20745146885f0f4ff7833934f76160507aa171b7fef16c"
  end

  uses_from_macos "ncurses"

  def install
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"

    PTY.spawn(bin"smenu", "--version") do |r, _w, _pid|
      r.winsize = [80, 60]

      begin
        assert_match version.to_s, r.read
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
  end
end