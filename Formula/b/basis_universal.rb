class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://ghfast.top/https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v2_0.tar.gz"
  sha256 "9ce167fcd6d4c45acf0cbb7fb9cf9ed5655330acbf12104558bcdd683c60ad14"
  license "Apache-2.0"
  head "https://github.com/BinomialLLC/basis_universal.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e3b3a0ad370f117b59bc5b26bd06475a7339146ec7d6aedb313d8170aa37598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1edef8db338532f7b96f147ece71e3d9c2c193e2a38968b56e751514b4754320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7f8d185c33c72937fdbcde96fc63c585b37fa79569a77e2728aa4eb07a0cb38"
    sha256 cellar: :any_skip_relocation, sonoma:        "d19fb4bc319c68647cd7a862c5059fbbb2ab77a161340654061c98f515c56459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f99e2dc2ac83f608c2048912451ac7de21bd595bd8245b290e95f623d363c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "768219f1b95dd54fad3adc2edfe6d165e780731b4000b6e752db03ebb41206d3"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "bin/basisu"
  end

  test do
    system bin/"basisu", test_fixtures("test.png")
    assert_path_exists testpath/"test.ktx2"
  end
end