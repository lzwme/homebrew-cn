class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https:github.comawsaws-lc"
  url "https:github.comawsaws-lcarchiverefstagsv1.52.0.tar.gz"
  sha256 "f8e948a23eba174cc5cd07f86983bace3828cc870214d3a4d1ea7111112394e4"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47ffd9d7713dc6dbfeb471e1b2fc13091cf9c7e97005d11e50b3196d8f63dd06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "302b9ccb33a494410954690fedab58055dd825bb7c149663d29eac31c15b8f00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28eba40e3aa00ce0dd36b2f851579895236f457b04e6b0a57c8ba73aea8f9074"
    sha256 cellar: :any_skip_relocation, sonoma:        "223beae8f0d9ad41abc4c8cb264860d917d6f2110e868346ceb412c7edffb19b"
    sha256 cellar: :any_skip_relocation, ventura:       "c10c8d95acb71a336636bb8f4931a1845f660522f52da85ba098f2cbd3bd0a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14865e1eb5b5e2894cf0346a9c3edf62a60c903e8eac66fca36ba26928d036a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9075d5239ee23f71f03f67f9e51e9d7086fbe70b78d2dec800e47a863e1c2091"
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