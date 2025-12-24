class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "456e0a32185a8e0a549d4e92f0cef1419d2c030b0e055fc215915e3b27813d50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4319190acbbdc39223ebc93b24445d5ccc20eb11e6987c11ad2eec2151692548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff1480844ba4377e1d9e4118402a86b26accc47f68ed9619cc746a6f88fb6b9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d16cd9a82dced50213966d173a5783c428f277efb6aebf472fd20b9f735e8db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "330e795edb80b37323830af1c7a5d1fe6110ebe20de99db9e98e91a56d52ac04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21a4ef45f3f6dff3feacd161490736108f30f34aec5ea591ba614a3b14558c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceaa74e8432249a38d5e72c2f9bf0f34c5d1757224da33439baaf5a6cde12637"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end