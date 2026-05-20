class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.100.0.tar.gz"
  sha256 "fb410827ff898f4de7f1893d8f554b4aa6b117b20478a1a55774b2c616770d68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbaf28914f1d89b4c1ec49da6c979250e242160f546a73cd063a0b24fd8fdbbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5abf0f4f6ed309c73030490a30a47076bd5cdfa04a328a670cac057178f1d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efae7bca03c3988620c0129ddc1a008f437dbd7fdf1efc54a6aafe9e514166b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b7fed09f737a108a4922560ba78f9b78b2ba3891c26325d22ef8c8e3f175dc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3456138b1232fc23d10ee310769e2bc40d13a4f4a3538556919b0dd7739bcd10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec7201a7ed56bc0647e8382ab96478e515d58bfcdeeb780709556607bb91097"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end