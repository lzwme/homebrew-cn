class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://ghfast.top/https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.23.tar.gz"
  sha256 "04d2655074457e17aad12b584e167995cee464532b7b909dcebd3445461783b8"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87239b7a753afdd60c562f2add48ae5b5eb6cd1bc0635777f1cb44c4a2913c5d"
    sha256 cellar: :any,                 arm64_sequoia: "05f0a7b049eb2d90fea57b731910b4936a9ff6649b82a23684da7455a02b1822"
    sha256 cellar: :any,                 arm64_sonoma:  "dec9e593e35dc1605fd81e4a15f0402acc13c5b0f55755af645f706f7530a271"
    sha256 cellar: :any,                 sonoma:        "03b0d914e25d932d6a35ebcbd65add0f412f8428972446cbbfcde43a1b592e1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad42f7f27eb1443eeca5de35dacae4e4c8e5071f8b2dc08f3f79bd30ea3e9bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c939e7189c1280172a87068eb4bae9df43dbd3b17d89be4dd7497b8c63ec3c9d"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "mcp-toolbox", because: "both install `toolbox` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end