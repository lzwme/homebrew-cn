class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https:github.comp7zip-projectp7zip"
  url "https:github.comp7zip-projectp7ziparchiverefstagsv17.05.tar.gz"
  sha256 "d2788f892571058c08d27095c22154579dfefb807ebe357d145ab2ddddefb1a6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e162e6e442c02511ec34dab3936dc326ecdaeb995a65fa786cb585deead847f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19bf0feb4e993c7cfad0d42bf8b9820ba67a9ebbd7ad4efd312a4a7953704a1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba7f3e60841e85ab16ae76e7f0be634e15ea1b0c4a3a631cbe57447cbc9d77b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed5af58015207456c265187cd73b53a80db239a9029bed1579065faa2391fec1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "145a4d0ecb748931931030b2e8844d5e007cba92cfed3b4ae07b4f15bc461e22"
    sha256 cellar: :any_skip_relocation, sonoma:         "2827eb7db9135c059d4498667e08ac37e4e020d39df6df0cebb1080d09cea9c5"
    sha256 cellar: :any_skip_relocation, ventura:        "6b4bac2c955ef9902583dafa2f9bf6e0e3f5d503c81e51c1ed1ddde01b2ae4df"
    sha256 cellar: :any_skip_relocation, monterey:       "91623462e2bdad09edfa899267359fcfd03ab34d8b70176462b1364e6f23f91c"
    sha256 cellar: :any_skip_relocation, big_sur:        "663d0ac5174855af24bf4dd7b729ef5693b7a421327379ba2d210b370f12aef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a421f6e2445fa536da9ab14e83060f3a2949cbdf1e5ac38484339e7b6b22fa04"
  end

  # Remove non-free RAR sources
  patch :DATA

  def install
    if OS.mac?
      mv "makefile.macosx_llvm_64bits", "makefile.machine"
    else
      mv "makefile.linux_any_cpu", "makefile.machine"
    end
    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end

  test do
    (testpath"foo.txt").write("hello world!\n")
    system bin"7z", "a", "-t7z", "foo.7z", "foo.txt"
    system bin"7z", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", File.read(testpath"outfoo.txt")
  end
end

__END__
diff -u -r amakefile bmakefile
--- amakefile	2021-02-21 14:27:14.000000000 +0800
+++ bmakefile	2021-02-21 14:27:31.000000000 +0800
@@ -31,7 +31,6 @@
 	$(MAKE) -C CPP7zipUIClient7z           depend
 	$(MAKE) -C CPP7zipUIConsole            depend
 	$(MAKE) -C CPP7zipBundlesFormat7zFree  depend
-	$(MAKE) -C CPP7zipCompressRar          depend
 	$(MAKE) -C CPP7zipUIGUI                depend
 	$(MAKE) -C CPP7zipUIFileManager        depend

@@ -42,7 +41,6 @@
 common7z:common
 	$(MKDIR) binCodecs
 	$(MAKE) -C CPP7zipBundlesFormat7zFree all
-	$(MAKE) -C CPP7zipCompressRar         all

 lzham:common
 	$(MKDIR) binCodecs
@@ -67,7 +65,6 @@
 	$(MAKE) -C CPP7zipUIFileManager       clean
 	$(MAKE) -C CPP7zipUIGUI               clean
 	$(MAKE) -C CPP7zipBundlesFormat7zFree clean
-	$(MAKE) -C CPP7zipCompressRar         clean
 	$(MAKE) -C CPP7zipCompressLzham       clean
 	$(MAKE) -C CPP7zipBundlesLzmaCon      clean2
 	$(MAKE) -C CPP7zipBundlesAloneGCOV    clean