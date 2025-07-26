class Fastga < Formula
  desc "Pairwise whole genome aligner"
  homepage "https://github.com/thegenemyers/FASTGA"
  url "https://ghfast.top/https://github.com/thegenemyers/FASTGA/archive/refs/tags/v1.3.tar.gz"
  sha256 "e23d24c7cf3a58c4a3db3facb8a341070a41a95bdb790438fb58009f8edf3eff"
  license all_of: ["BSD-3-Clause", "MIT"]
  head "https://github.com/thegenemyers/FASTGA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5121a0661a2e9dc341e14d4ac1fdbd21c8cfc73cbd563f2f53eeee9c469283c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d541b3868cfcbfa838b8ffe66f5fd7c911369359364577e37d4969eeef7cf34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "750addc55ceb7c77b59b086f1fcbf0a24e7855907fa6bfb38f0e2b253d054a3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c4102a76f0fae735c3367fcad55e659b3d5e6253e519e5f3e398349846f0c4c"
    sha256 cellar: :any_skip_relocation, ventura:       "1e2e526601914fc9d5d933c5ab41ca27ad52f431e8f5485976f8651905d5bc98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac1f9a4625eb4499392d57e00f35c50cb4567f24cbc003738af7f5d32899a2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6a932684a1ea9941a9dac6b295c9a6cd67773dc1c97e9054ac2168a644631e5"
  end

  uses_from_macos "zlib"

  def install
    mkdir bin
    system "make"
    system "make", "install", "DEST_DIR=#{bin}"
    pkgshare.install "EXAMPLE"
  end

  test do
    cp Dir["#{pkgshare}/EXAMPLE/HAP*.fasta.gz"], testpath
    system bin/"FastGA", "-vk", "-1:H1vH2", "HAP1", "HAP2"
    assert_path_exists "H1vH2.1aln"
  end
end