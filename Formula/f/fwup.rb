class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://ghfast.top/https://github.com/fwup-home/fwup/releases/download/v1.13.1/fwup-1.13.1.tar.gz"
  sha256 "3e71ef0a422702f15aa60ba1137c89d76d7da97ddbb4f5a5c9b3c5ca2e339a67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de170a5e7ce11c43d8b86d032c7bcc2a48dce669c77a4558f67b7a2649de5034"
    sha256 cellar: :any,                 arm64_sonoma:  "dc3361a7ce64de4a45b1dbbbdd80eeb57103b503c0751aa0cb28124cfa07b527"
    sha256 cellar: :any,                 arm64_ventura: "336e99416c39d32ad6a4a7a62bf442375c099d9a2c86b19521ddca2dbad49fce"
    sha256 cellar: :any,                 sonoma:        "b30c0887c5cee2ea99b778f54c4d7be18ec9870f46a29217be5ade4461639a81"
    sha256 cellar: :any,                 ventura:       "0a5e695039f64edabf8d67aa0276640c55e54b0a459936ec98cedbe2deb231c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baeb1461ac2aabd72eb96cce42a2dd923a5b1420afb1a543e97aa71a4df762aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87daf344c2a7b0c61039ce3b97aeb33bf41dc4af3845ee2698cdd3e87e7589e2"
  end

  depends_on "pkgconf" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_path_exists testpath/"fwup-key.priv", "Failed to create fwup-key.priv!"
    assert_path_exists testpath/"fwup-key.pub", "Failed to create fwup-key.pub!"
  end
end