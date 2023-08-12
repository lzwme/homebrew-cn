class ClangBuildAnalyzer < Formula
  desc "Tool to analyze compilation time"
  homepage "https://github.com/aras-p/ClangBuildAnalyzer"
  url "https://ghproxy.com/https://github.com/aras-p/ClangBuildAnalyzer/archive/v1.4.1.tar.gz"
  sha256 "bee3028091a41005a3e0988a1c6a1dbeb500ea45114bcc3244faada9fd551226"
  license all_of: ["Unlicense", "Zlib", "MIT", "BSL-1.0", "BSD-3-Clause", "Apache-2.0",
                   "BSD-2-Clause", "Apache-2.0" => { with: "LLVM-exception" }]
  head "https://github.com/aras-p/ClangBuildAnalyzer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce9947ee73afdc65b9d4448f37157f47c6c04c2ea6e1ae898b168961d8c31958"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36bb9c617dcaf0b87ac3da660bde96b2decda0efc294363f41de983917b99ebd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc921a909b2190cd523379d517feba97448726b701397f1a3bfcb85e26458d24"
    sha256 cellar: :any_skip_relocation, ventura:        "167521e0973aa7868a438baab81353a3f7e65c12e343b3a527b28b196263acea"
    sha256 cellar: :any_skip_relocation, monterey:       "56472176442afcd0b650ff79b1a1a4590141eb631bd7a67526dc597debb597f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "16fe39935e3f80eedec4e8a8604ae0c4f3d5a34631e0e8eeb670246122b66d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91f1cc3ff1ad0b28a9147ac0aeeeaeedcca689f870b1e8a109ed2cf5805ae1f2"
  end

  depends_on "cmake" => :build
  uses_from_macos "llvm"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~EOS
      int main() {}
    EOS
    ENV.clang
    system ENV.cxx, "-c", "-ftime-trace", testpath/"test.cxx"
    system bin/"ClangBuildAnalyzer", "--all", testpath, "test.db"
    system bin/"ClangBuildAnalyzer", "--analyze", "test.db"
  end
end