class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https:github.comkimci86bkcrack"
  url "https:github.comkimci86bkcrackarchiverefstagsv1.5.0.tar.gz"
  sha256 "ad33a72be3a6a0d29813cbb5f5837281f274cb3e13a534202afccd2c623329d0"
  license "Zlib"
  head "https:github.comkimci86bkcrack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c419cce3ce9587ec353e02ccce602bd91d0c5b53055d28f76a0627b85f95b220"
    sha256 cellar: :any,                 arm64_ventura:  "2865bf429159aa33ab4f0f915c0aef8f1b7f7ab070879fc201b289f3f53a3bf9"
    sha256 cellar: :any,                 arm64_monterey: "c803a2e3a1c609f5511a7e8b2bb763e18b8152cbb63ac50e928ec96d949c496e"
    sha256 cellar: :any,                 sonoma:         "d940038cfa8dab4e655d037c66bc7d7eb554933a10c009f5c4db2feeffc1deab"
    sha256 cellar: :any,                 ventura:        "4bac76285fefb933c46bbbe10b51c5a0baf119a2b3a55ca7d104050fbabd5bcf"
    sha256 cellar: :any,                 monterey:       "113a40fe442f93011b28e5b883976ca7601f2403d6eb0809149ad127cc6a9540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37469df21c1ed06839879d04d3d9e2fb0620974e9bb13536c1d06848d950f2fe"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "buildsrcbkcrack"
    pkgshare.install "example"
  end

  test do
    output = shell_output("#{bin}bkcrack -L #{pkgshare}examplesecrets.zip")
    assert_match "advice.jpg", output
    assert_match "spiral.svg", output

    assert_match version.to_s, shell_output("#{bin}bkcrack --help")
  end
end