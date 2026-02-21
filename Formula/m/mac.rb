class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1234_SDK.zip"
  version "12.34"
  sha256 "a4abeb64e7e63f1f3353c72862b1cb37c41700af97013593ece2098f100f797b"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "113bb8840d9bded34c3a80a7abcad38ca86d8da5b15a454c624373289de12953"
    sha256 cellar: :any,                 arm64_sequoia: "7d3e7eec980f1f0bbce576307bfef7942c0fbc6bb4df3a5fa700ca680eab4af9"
    sha256 cellar: :any,                 arm64_sonoma:  "70eac3eea3db633a519f9d9bf770e6c0ce634b1888f30f3994f7b4d125fb6e6c"
    sha256 cellar: :any,                 sonoma:        "6e02870a983731a5f5a03e22eb8197b65f1ac0cf5a9797591d8f3a806add911d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e0f3b4c244a0810c41232e426eb42add56b0691443eb3c8a8a48213eec88d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3afcd8c2a902b7bd5732651486fba60ad7dbd245a0450dd0b46c43fd26bffa5"
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