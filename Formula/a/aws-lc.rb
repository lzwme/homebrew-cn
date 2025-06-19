class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https:github.comawsaws-lc"
  url "https:github.comawsaws-lcarchiverefstagsv1.53.1.tar.gz"
  sha256 "74137613ea4e322600400fdc2e21c83f08f4c68d368ebe006eab264e4e685e01"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7797774722a66a93873471402ec6d4b0dbb675299a613392a1dc684b970cdd22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e8597271d0c1152e185035f36ad1188740a555ac9717f93b98ba6a60529e5a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8b4c162ca19610a2b6aec5896f94aa423e5e6e25a36914cfe43e3e9ef193889"
    sha256 cellar: :any_skip_relocation, sonoma:        "1603b0dc0a437d18a0a64ce5acea9924dde856273a13e0fc1322a4a76d41989f"
    sha256 cellar: :any_skip_relocation, ventura:       "d9f4f9df4bba7be6205d45b4646d410cf13006f3f3cc2e822782f1b86632b0f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2356151192a160fbb5a7333771263193201236864944110cb89811cde5eee06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b729bdb0998b87b0c199c44f81ec914376e5b04035d115d36439b041126d7a"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "perl"

  def install
    args = %w[
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DCMAKE_INSTALL_BINDIR=bin
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    output = shell_output("#{bin}bssl sha256sum testfile.txt")
    assert_match expected_checksum, output
  end
end