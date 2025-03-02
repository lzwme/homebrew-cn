class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https:theunarchiver.comcommand-line"
  url "https:github.comMacPawXADMasterarchiverefstagsv1.10.8.tar.gz"
  sha256 "652953d7988b3c33f4f52b61c357afd1a7c2fc170e5e6e2219f4432b0c4cd39f"
  license "LGPL-2.1-or-later"
  revision 5
  head "https:github.comMacPawXADMaster.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "88b011e1e61a3422988ca90b01e71fac6d7883db613c3291fba1b35046090c22"
    sha256 cellar: :any,                 arm64_sonoma:  "e3914d0d21ef96d413f94bc0d3bcdb2dd4bba6e17b1e5543940297f6747ff3bd"
    sha256 cellar: :any,                 arm64_ventura: "11743466c012f30198def083984fb8c4b0d31447012df6109c3a04f8445f13b9"
    sha256 cellar: :any,                 sonoma:        "cae1803e4689f0ed4c392408bd22b602c9c4ec4ed24d16f52b239e01cf286ae7"
    sha256 cellar: :any,                 ventura:       "fad1370b6b0fafde0cf8ccf525754ef6bb1d736df80968f3ca44073605407984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df779ffa5a0db66776069dfce6b15428c565360f7664bc19309144f8b180f8e0"
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
      bash_completion.install "unar.bash_completion" => "unar"
      bash_completion.install "lsar.bash_completion" => "lsar"
    end
  end

  test do
    cp prefix"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}lsar README.md.gz")
    system bin"unar", "README.md.gz"
    assert_path_exists testpath"README.md"
  end
end