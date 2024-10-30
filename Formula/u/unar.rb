class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https:theunarchiver.comcommand-line"
  url "https:github.comMacPawXADMasterarchiverefstagsv1.10.8.tar.gz"
  sha256 "652953d7988b3c33f4f52b61c357afd1a7c2fc170e5e6e2219f4432b0c4cd39f"
  license "LGPL-2.1-or-later"
  revision 3
  head "https:github.comMacPawXADMaster.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f1958e4685c8f612da2716e61aa50bf3ef09aa9f0f24fb053dbf87ff13543a5"
    sha256 cellar: :any,                 arm64_sonoma:  "32926d24931d2431fc1de377976d2be0e3bb9d081c41b96ffb88ac01c79abcd0"
    sha256 cellar: :any,                 arm64_ventura: "b38a14f5b704caecf2f1cdbddbd3850f4f47500710a38843e28ac4a3da066c9c"
    sha256 cellar: :any,                 sonoma:        "f2e10ae563fdc2433297285c858ecd768a74de3d4dfc85d64a2fe083c5980b9f"
    sha256 cellar: :any,                 ventura:       "f5f982cfeeb2e0fb4830116fd4fa99eaeff3102afd7d972efe5c66a167d1e8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f862f808fa584872c7e7e8de2430327cd2745634f0529d2fbc5d8fc54468b03a"
  end

  depends_on xcode: :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnustep-base"
    depends_on "icu4c@75"
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