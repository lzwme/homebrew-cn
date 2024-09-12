class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.54.5.tar.gz"
  sha256 "51cb922a04bcb960ba1b33ffd446b780832ace0f760a9f000bd17f345e86e82b"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3fc57cb9abcbfd64106a3b16f51c8851c9877327553ec5fd9b21683d42b3c18d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d1f7565498827bbc53230f01c2fca4a7d082f4ae16d32ae568ba633c090c6ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "416b54dc7938754980f9b2d732254ce7a36c401c2df3b68eba47f54db9bb956c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b14b0bacb0938c650e2d0d30d1f546ea7bac4feac510be16f09a89abd9f95d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "445a0e38bda1f1dbda7c34dbb75a1b4432c5f0de7f9fa8bd4e03a9220b9bda19"
    sha256 cellar: :any_skip_relocation, ventura:        "508b2e8000078773c7884e17b8d1ca711f4313ba14ff0000f7a28af68b02e71a"
    sha256 cellar: :any_skip_relocation, monterey:       "8c367a76ca05ba07ffc38a6bb2f5ee0231d363655ed982284afcb4d685fa524e"
    sha256                               x86_64_linux:   "8e8abc969e1b10e7411a92717703c8cd944c7a3f3fd04e2d232918971ae14662"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleaseswiftformat"
  end

  test do
    (testpath"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system bin"swiftformat", "#{testpath}potato.swift"
  end
end