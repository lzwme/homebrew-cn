class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https:github.comawsaws-lc"
  url "https:github.comawsaws-lcarchiverefstagsv1.54.0.tar.gz"
  sha256 "d491b6d6b233e88314a15170d435e28259f7cf4f950a427acc80a0e977aa683a"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81ccd5017a1ca29a020e68fc16ea33e37d342d1efd6dc8a5feb1850391003ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b1889f117d645e0c9a132a46c54b9ccceee081a2b3690c76aad27009b57b5df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d91bcccf2bc1baa246253ed80994cb14584df9c3fb6dff7a1c64fab95c7bed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f248c8e69eb12bbb4f817c3ab6293e9ffa78bb542abbe7fee4a08a1524c7ef"
    sha256 cellar: :any_skip_relocation, ventura:       "19b9fb48483ca190a0605a9d47fff454824e8dff763fc3258dd182ed4d9817c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40615e3ae1c5e90a3773ea9b6dc4121facf01f0e2e580aa3aee78319ffe91866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3204c55b6de6d48129edf0a1e363427e51bb73200df7c68d6a760c7ac63ebaa"
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