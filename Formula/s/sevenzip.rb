class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2501-src.tar.xz"
  version "25.01"
  sha256 "ed087f83ee789c1ea5f39c464c55a5c9d4008deb0efe900814f2df262b82c36e"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)\s+\([^)]+?\)/im)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc707e54e639a99f4bb1041dcdb981890b80711023d5d86122ad6f2fc75e9a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3254fd85c69624613c4d2473bf0962cd0a6da95426db4103e7085a2eb6fb6523"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98b39cffa36a599b640eba229458461a1b9658b5a6ce1495ed9c06194ab7701d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1de5040b9b80f5711eda3f3dc75555c5b6a2eda7d20eea1a8d6ec56ab3583c62"
    sha256 cellar: :any_skip_relocation, ventura:       "93471f3ededabe6868538922a8268bef618ba992f2504826c37a391e3f7e3271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7503b0032b2724f7244f8fbf56be566bb31450973a120ea8a3380decf5b2c7e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a9255bc26eba7518647e9ed69790864aaa3e0d16bb932856c318b468fab9f8"
  end

  def install
    cd "CPP/7zip/Bundles/Alone2" do
      mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
      mk_suffix, directory = if OS.mac?
        ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
      else
        ["gcc", "g"]
      end

      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"

      # Cherry pick the binary manually. This should be changed to something
      # like `make install' if the upstream adds an install target.
      # See: https://sourceforge.net/p/sevenzip/discussion/45797/thread/1d5b04f2f1/
      bin.install "b/#{directory}/7zz"
    end
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath/"out/foo.txt").read
  end
end