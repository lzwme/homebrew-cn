class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.7/proteinortho-v6.1.7.tar.gz"
  sha256 "4968b1208513e677d5474a6ce081b84e6f0a6dd000975a41273dac51fc02e7d4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0f61f0156caff71712ffb4183ce10763f80f084247bd2b963601c32c7afe7b8b"
    sha256 cellar: :any,                 arm64_monterey: "a5a08ff121f82198a62ed505c94aad4b487b320e1ab9b3082eafa2fe4a17e957"
    sha256 cellar: :any,                 arm64_big_sur:  "b564416df5fc5d9f39a8fe5d38571eaf7b4ebc70c71946d194b0179aa486f915"
    sha256 cellar: :any,                 ventura:        "d8a82a3f36e52ee19d2856889cb5e239d72a2ecd5005261e7116591b40e853a3"
    sha256 cellar: :any,                 monterey:       "5bea033899116bfae1a9ca4a0886812672526685e573f92c81d3de958ac36b3d"
    sha256 cellar: :any,                 big_sur:        "86f06b6e7c710a347436811e605f0a74d57eb240b9815923278f75d89cea4604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2331a7a5cd3914bf348d0918964707164e47e5b19e198a1980e2a13c9bc16575"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end