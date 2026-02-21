class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://ghfast.top/https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v2_0_3.tar.gz"
  sha256 "eb9ac9ec933524b3c97720368b5cb423fa8767bfc409029d4864063e0d078bec"
  license "Apache-2.0"
  head "https://github.com/BinomialLLC/basis_universal.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dc7c611ed4004fc0dcdf042aa0747285a3f0b2897b65a3e7399301f6de223dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2de04be66915e2929703aacf46313f04a7da47958c23f21b7d1fab01df688a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a24baae239117c62cd20ca94000206ad2267dc3f0af9f56887d8f927416d43e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5eb258e55b03bb874b3bf6f8bc9e24e8410c94ce0b381edef1b4c2d25b08818"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf15b0a27c515239009bffe662c5af46aaeaa95e3bc4524a09762bdfa0ab5907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c28de13b23e24e6fa486df544bb774a9af405dd3ab1ed2ec82b2b6f71718e5d"
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