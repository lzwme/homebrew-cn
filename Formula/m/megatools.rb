class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://xff.cz/megatools/"
  url "https://xff.cz/megatools/builds/megatools-1.11.3.20250401.tar.gz"
  sha256 "6f38f01c085c1521cbebbde20f5a2be3dd1d65d8f04f8f35d09cb56cabd4febb"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://xff.cz/megatools/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "20817f17e650c907ce775abc7a018876bda3704cfb27884381f94a3355c47bca"
    sha256 cellar: :any, arm64_sonoma:  "af0f39656b56c9254bf669ce9fce9396c66a64b4fe7cfc500cc6cccca0af8653"
    sha256 cellar: :any, arm64_ventura: "37e809a67ea58d5ab3c3832f0672c020c8020c912362208b98fc6f09f4fe79f7"
    sha256 cellar: :any, sonoma:        "811079dfcf9f077bf07b1b68896695834caf4d0a20dd4e3496dd27ad9e4fbdb2"
    sha256 cellar: :any, ventura:       "1ec547bcc384c1503e6504a5e875239d7037b73dd4d041423a2fda3b431a3f46"
    sha256               arm64_linux:   "43f9a8cfec55acb892547d6f573e215806186f6e8cba92fb14613b04ffebe721"
    sha256               x86_64_linux:  "74298fd2bb7b4c58b8ebebdef973827377761d9968f69a323e27bd6cc634296d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "openssl@3"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system bin/"megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal "Hello Homebrew!\n", (testpath/"testfile.txt").read
  end
end