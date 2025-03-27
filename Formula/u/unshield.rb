class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https:github.comtwogoodunshield"
  url "https:github.comtwogoodunshieldarchiverefstags1.6.0.tar.gz"
  sha256 "c3974a906ddbdc2805b3f6b36cb01f11fe0ede7a7702514acb2ad4a66ec7ae62"
  license "MIT"
  head "https:github.comtwogoodunshield.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "948ea2cbe599525c46b8a9e9147275a9eb261fca844f94056ee630e56e0499e8"
    sha256 cellar: :any,                 arm64_sonoma:  "4eaad7083ab417b2b810f2cfa9716e3335299a98ac0820be5fed50b146358976"
    sha256 cellar: :any,                 arm64_ventura: "50fdfb819059fec9bd18f799d01a0a32d8809f6519aff0d93c3ed73fb01b4a80"
    sha256 cellar: :any,                 sonoma:        "26d93af0c1a1c877f0a09a5e481ce26a4066c31a128412b7c809509b776a9a0c"
    sha256 cellar: :any,                 ventura:       "0b051dff0091b739a4bc0f0a2e5253bb53a3b1f41292def27e2b10d170d4a00c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e952ebf9e7dfcd9a5471b873210f459609c9b7e491ae42548ba6f50d147efe58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3db3e45a7c3de29160e9d276c2e0b6d5594062bceae05d074e81cf6b3084efc3"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # cmake check for libiconv will miss the OS library without this hint
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DUSE_OUR_OWN_MD5=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"unshield", "-e", "sjis", "-V"
  end
end