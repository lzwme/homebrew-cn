class GitNumber < Formula
  desc "Use numbers for dealing with files in git"
  homepage "https://github.com/holygeek/git-number"
  url "https://ghproxy.com/https://github.com/holygeek/git-number/archive/refs/tags/1.0.1.tar.gz"
  sha256 "1b9e691bd2c16321a8b83b65f2393af1707ece77e05dab73b14b04f51e9f9a56"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9a99641367e1379e7150b0b4a4d82265e02f4262b35eb791c057595a14f14ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9a99641367e1379e7150b0b4a4d82265e02f4262b35eb791c057595a14f14ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9a99641367e1379e7150b0b4a4d82265e02f4262b35eb791c057595a14f14ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f357699b108c2e521721c7a8a93ee188a526b47a5f1af7841cf005d2d1008f4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9a99641367e1379e7150b0b4a4d82265e02f4262b35eb791c057595a14f14ae"
    sha256 cellar: :any_skip_relocation, ventura:        "c9a99641367e1379e7150b0b4a4d82265e02f4262b35eb791c057595a14f14ae"
    sha256 cellar: :any_skip_relocation, monterey:       "c9a99641367e1379e7150b0b4a4d82265e02f4262b35eb791c057595a14f14ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca7a48d9827be6cc0d625891e25b7b7b7474d9c33a276955ab3f0eb14b8cb21b"
    sha256 cellar: :any_skip_relocation, catalina:       "662840b36a99f95902aee618faed6274d2cf9c6620b9c01855377d85d838eaad"
    sha256 cellar: :any_skip_relocation, mojave:         "2fc24b4bb5404f85fb6c359ac9b8c969846953176d8a01176c4e6ddba3067bc9"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d71548120a8d5d9db4b9b9ae71be947303c6a415e35380d0d8e36551765b827f"
    sha256 cellar: :any_skip_relocation, sierra:         "d71548120a8d5d9db4b9b9ae71be947303c6a415e35380d0d8e36551765b827f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d71548120a8d5d9db4b9b9ae71be947303c6a415e35380d0d8e36551765b827f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8bca68db296e388c3290a4c805720e710e74b38482db38cebc1d3c78c96b924"
  end

  # Fix for main branch name in tests
  patch do
    url "https://github.com/holygeek/git-number/commit/3da16b37716455ef1dcc9f617a89e003581b5188.patch?full_index=1"
    sha256 "6e7ed0dfcd86b1e8ee4ada9688aa12be9e33c4d9bb6928cf59dda653aa3c716e"
  end

  # Necessary for next patch
  patch do
    url "https://github.com/holygeek/git-number/commit/743d06416f097da4f39f4be7883aa755c8a2edfb.patch?full_index=1"
    sha256 "88544a6312df728e83dd7c421be57427a155742e51363903c48a707b8e29ade7"
  end

  # Fixes fatal: transport 'file' not allowed, remove with next release
  patch do
    url "https://github.com/holygeek/git-number/commit/e699e92394fa6a4ecbc4d7235925e9080a61aaa2.patch?full_index=1"
    sha256 "92d77a6c06fd579e79ab95c9c2d1d461d0f4e0a7fc28217dbb24aeae60d0bec9"
  end

  def install
    system "make", "test"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/git-number", "-v"
  end
end