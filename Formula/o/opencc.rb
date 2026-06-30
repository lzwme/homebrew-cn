class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://opencc.byvoid.com/"
  url "https://ghfast.top/https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.1.3.2.tar.gz"
  sha256 "8aaaca60b160cfba47f83589a2a20cf38ff360e5cb20546c94ee60af8dfa6594"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/BYVoid/OpenCC.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "40b4c637f5065d8d6822c4c0a5eae96bc9d596a65191cc2b034445248aba7136"
    sha256 arm64_sequoia: "67ebd0ff2a827dead0b7cd39b9cdd5266ee51c5017a2fb9e79cc163d618d3bde"
    sha256 arm64_sonoma:  "fcda4c8ea19061e936b68c8d24d39c7f7f5bfa8523b91ca1845f25596f8853bf"
    sha256 sonoma:        "b3f57798652cdcc874bdbffd4dfb01b3aecf4d4deb8dea6513ffaad0f757c7df"
    sha256 arm64_linux:   "3bdb883a65ff83a30ca85577f07db865e9db0338ea3598f7e42a2177bc9f8d4f"
    sha256 x86_64_linux:  "5563253775e81677784928fff603d266e6c2af3594f1fc722020e5e512a72038"
  end

  depends_on "cmake" => :build
  depends_on "marisa"
  uses_from_macos "python" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
      -DUSE_SYSTEM_MARISA=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = "中国鼠标软件打印机"
    output = pipe_output(bin/"opencc", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end