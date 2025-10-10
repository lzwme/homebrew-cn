class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1157_SDK.zip"
  version "11.57"
  sha256 "3b7a8b5b23dc8084ae5c675a827530b0e773cb61a01d8a019fca5a05e3b82ec2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9955f3e6d197123ba353959ea4144eac94f6fb8e988c6b5390141a3cf6a7dc72"
    sha256 cellar: :any,                 arm64_sequoia: "9f856a2a1e39d52dbeee75ef8baa9cee9571c9615af9c7ec1aee2a2b0dd9cb32"
    sha256 cellar: :any,                 arm64_sonoma:  "f8376ab3dc082b33da718f69e5dd720cf873d9678bdfdf5e309eec597dc11224"
    sha256 cellar: :any,                 sonoma:        "5ab80a545aad7790a2c0ed30a031e57852f580a2e6fb98251353f9cbec311d2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "021585eb51cefb99550ceeb94444433cd7a2154c96300c0acd7e9809fb4f97aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25dd172381c486636a6bab9d55a58864b6db44231172b6cf5a4f62ded0d0ea29"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end