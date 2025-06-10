class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https:github.comGPGToolspinentry"
  url "https:github.comGPGToolspinentryarchiverefstagsv1.3.1.1.tar.gz"
  sha256 "ba929dd1c57b102fbfca12bc2d784be441498e7c82ee97a1231cbe03dcda7ae9"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]
  head "https:github.comGPGToolspinentry.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f0cacdc9497edf7391983fe84573ddfd826d0315680847a3f78ec020b6d145e5"
    sha256 cellar: :any, arm64_sonoma:  "6c879dba2621079072e566b95c00f96e7731a164dc6206054933058375df7014"
    sha256 cellar: :any, arm64_ventura: "9fd717f5a5b6223bd307503d72290ba678b8f0af9d185e952741bd6f73dab482"
    sha256 cellar: :any, sonoma:        "bac8b8241d3fa0eaaba5bb9073f1f5a32fa064ab59ab2f230a1e86efb432d9d8"
    sha256 cellar: :any, ventura:       "e454945cc2ca007d6c030f75389380aa3892183bf9214181c98b5949cc3ecddf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on xcode: :build # for ibtool
  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on :macos

  def install
    system ".autogen.sh"
    system ".configure", "--disable-doc",
                          "--disable-ncurses",
                          "--disable-silent-rules",
                          "--enable-maintainer-mode",
                          *std_configure_args
    system "make"
    prefix.install "macosxpinentry-mac.app"
    bin.write_exec_script prefix"pinentry-mac.appContentsMacOSpinentry-mac"
  end

  def caveats
    <<~EOS
      You can now set this as your pinentry program like

      ~.gnupggpg-agent.conf
          pinentry-program #{HOMEBREW_PREFIX}binpinentry-mac
    EOS
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}pinentry-mac --version")
  end
end