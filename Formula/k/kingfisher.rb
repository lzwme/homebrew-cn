class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "e694314b63ddbcf403624cdc286bb044fa41a0894ce8d5dc3283f6ccd8765a3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c790ed0a7519c26258162e80c8ae2dc0b7bb6acfc8756a040402a72b38e7b58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97b198d0b7fdc1f4cd74c7392f33a863f844a5befe0db4d72fd85650f5f97791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cfd163fbd6ee9cbf0a388f56f0d381e750279c745930ecd3df42c27e938ed0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac5f0e68a1f1a9b88173169b5eeebca3d1ee9ac2bb44c5c8c835ef8e51f85ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edcc762816e7951aad46bd21948caaf3d57cef41a8c7223344d4114fd913379b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f307916c028165158af119ea87a4493b464570b9c88c0b4145a47652cc9e7f96"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end