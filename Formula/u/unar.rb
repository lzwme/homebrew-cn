class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https:theunarchiver.comcommand-line"
  url "https:github.comMacPawXADMasterarchiverefstagsv1.10.8.tar.gz"
  sha256 "652953d7988b3c33f4f52b61c357afd1a7c2fc170e5e6e2219f4432b0c4cd39f"
  license "LGPL-2.1-or-later"
  revision 4
  head "https:github.comMacPawXADMaster.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd858a235952d2155533a89449ae435c0a6f67853f5c0f729ba3586cb6fb3bdc"
    sha256 cellar: :any,                 arm64_sonoma:  "a62cfd49e413c678551cf87b8a40f9ae1a45841e6cef0bae5672acdc7b87231e"
    sha256 cellar: :any,                 arm64_ventura: "75504644bb166e35917edd1850d61f5ed209615a4892d3a444220532c1a29b9f"
    sha256 cellar: :any,                 sonoma:        "7e6806c94ca6f3742b35a0dabc4233e5d3dc09363a1a5cc0e8c5c18a13e0ee15"
    sha256 cellar: :any,                 ventura:       "b6f8500cb6592bf5c4f3d42f878cd59bb485349854f06293ff7f3d55418b106c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc17e96d8712f07a59b54b930faad63ddc4f33a69d90c925ca0a7d07bbd79b15"
  end

  depends_on xcode: :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnustep-base"
    depends_on "icu4c@76"
    depends_on "libobjc2"
    depends_on "wavpack"
  end

  # Clang must be used on Linux because GCC Objective C support is insufficient.
  fails_with :gcc

  resource "universal-detector" do
    url "https:github.comMacPawuniversal-detectorarchiverefstags1.1.tar.gz"
    sha256 "8e8532111d0163628eb828a60d67b53133afad3f710b1967e69d3b8eee28a811"
  end

  def install
    resource("universal-detector").stage buildpath"..UniversalDetector"

    # Link to libc++.dylib instead of libstdc++.6.dylib
    inreplace "XADMaster.xcodeprojproject.pbxproj", "libstdc++.6.dylib", "libc++.1.dylib"

    # Replace usage of __DATE__ to keep builds reproducible
    inreplace %w[lsar.m unar.m], "@__DATE__", "@\"#{time.strftime("%b %d %Y")}\""

    # Makefile.linux does not support an out-of-tree build.
    if OS.mac?
      mkdir "build" do
        # Build XADMaster.framework, unar and lsar
        arch = Hardware::CPU.arm? ? "arm64" : "x86_64"
        %w[XADMaster unar lsar].each do |target|
          xcodebuild "-target", target, "-project", "..XADMaster.xcodeproj",
                     "SYMROOT=#{buildpath"build"}", "-configuration", "Release",
                     "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}", "ARCHS=#{arch}", "ONLY_ACTIVE_ARCH=YES"
        end

        bin.install ".Releaseunar", ".Releaselsar"
        %w[UniversalDetector XADMaster].each do |framework|
          lib.install ".Releaselib#{framework}.a"
          frameworks.install ".Release#{framework}.framework"
          (include"lib#{framework}").install_symlink Dir["#{frameworks}#{framework}.frameworkHeaders*"]
        end
      end
    else
      system "make", "-f", "Makefile.linux"
      bin.install "unar", "lsar"
      lib.install buildpath"..UniversalDetectorlibUniversalDetector.a", "libXADMaster.a"
    end

    cd "Extra" do
      man1.install "lsar.1", "unar.1"
      bash_completion.install "unar.bash_completion", "lsar.bash_completion"
    end
  end

  test do
    cp prefix"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}lsar README.md.gz")
    system bin"unar", "README.md.gz"
    assert_predicate testpath"README.md", :exist?
  end
end