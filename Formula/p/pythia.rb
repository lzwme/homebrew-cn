class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "https://pythia.org"
  url "https://pythia.org/releases/pythia83/pythia8317.tgz"
  version "8.317"
  sha256 "1ae551d14dac495ddfe6b344792035ebe410fe6c6004d44a335e0ece0e745adf"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pythia.org/releases"
    regex(/href=.*?pythia(\d)(\d{3})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.join(".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "2941fbfcc53f567e97c62bf8154af156977892accdd8ea954b61596d7bbce87a"
    sha256 arm64_sequoia: "330a6e6a8f92479a137bfefaea5a6b996cce777a3f957a121abf6faa9b1ab33a"
    sha256 arm64_sonoma:  "5a40b3af7cd7afab37bd87c58c77a7c6eee0c980bbffc5f5459f20654f3bd2bb"
    sha256 sonoma:        "d7bd8c5bd64b0c6ce006e245c9f2b59cdaf70bd4676da0571cb0e1acc735debc"
    sha256 arm64_linux:   "5803ca24ee29b5727453f35aa6bf722d9ac7e0fc6e143934f24095e9c4dd8d99"
    sha256 x86_64_linux:  "c8d064a5b974c230b8da926afa06b4426918168bfae7870205285b0aee64c4fe"
  end

  uses_from_macos "rsync" => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include "Pythia8/Pythia.h"

      int main() {
        Pythia8::Pythia pythia;
        return pythia.settings.mode("Beams:idA") == 2212 ? 0 : 1;
      }
    CPP

    flags = shell_output("#{bin}/pythia8-config --cxxflags --libs").split
    system ENV.cxx, "test.cc", "-o", "test", *flags
    system "./test"
  end
end