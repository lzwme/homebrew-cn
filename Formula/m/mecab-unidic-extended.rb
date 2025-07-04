class MecabUnidicExtended < Formula
  desc "Extended morphological analyzer for MeCab"
  homepage "https://osdn.net/projects/unidic/"
  # Canonical: https://osdn.net/dl/unidic/unidic-mecab_kana-accent-2.1.2_src.zip
  url "https://dotsrc.dl.osdn.net/osdn/unidic/58338/unidic-mecab_kana-accent-2.1.2_src.zip"
  sha256 "70793cacda81b403eda71736cc180f3144303623755a612b13e1dffeb6554591"
  license any_of: ["BSD-3-Clause", "GPL-2.0-only", "LGPL-2.1-only"]

  # The OSDN releases page asynchronously fetches separate HTML for each
  # release, so we can't easily check the related archive file names.
  # NOTE: If/when a new version appears, please manually check the releases
  # page to confirm an appropriate archive is available for this formula.
  livecheck do
    formula "mecab-unidic"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c22fe677d5ab8e9fea7fdae111d0cb7af0e3971ccd5717c54e5e770cf46d5d4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "243fbb81ef84212672b3b793c96460ae56d66b61b2bad5ca965df3effcd959e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd9013ad7c93c14834061c6591eff7ef5fd67fe8508ee461ab484bd74e68edef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd9013ad7c93c14834061c6591eff7ef5fd67fe8508ee461ab484bd74e68edef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3afff6a9a967b7c92eb79ca6efcaf3289596c331214ba6130989d757cd7757b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "243fbb81ef84212672b3b793c96460ae56d66b61b2bad5ca965df3effcd959e7"
    sha256 cellar: :any_skip_relocation, ventura:        "cd9013ad7c93c14834061c6591eff7ef5fd67fe8508ee461ab484bd74e68edef"
    sha256 cellar: :any_skip_relocation, monterey:       "cd9013ad7c93c14834061c6591eff7ef5fd67fe8508ee461ab484bd74e68edef"
    sha256 cellar: :any_skip_relocation, big_sur:        "7566096a08a09b4c695c2f59766dc3d8ed5156d87180a3da1d504be9e038a30b"
    sha256 cellar: :any_skip_relocation, catalina:       "2624e794b1f765e78dbd593b50b8ea2b3055ede30192694cfc3ed7f5c4eb8a9b"
    sha256 cellar: :any_skip_relocation, mojave:         "7b297ee9b0d51169a5d5f7dd7047c1aaf18ade6bcaeccf2b570263aa6ab694b2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8890b4d95d0c3ee114ec48ea95d66c1d8b8a273949a912140fa477ad9265be0b"
    sha256 cellar: :any_skip_relocation, sierra:         "8890b4d95d0c3ee114ec48ea95d66c1d8b8a273949a912140fa477ad9265be0b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "8890b4d95d0c3ee114ec48ea95d66c1d8b8a273949a912140fa477ad9265be0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6ea4b9b91cb3e1b611eb27a4b1602cf6488dc719d887e5c8ab0aec5ea4184622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4445b4f69062be6b5142324088eef2a83e958a584665e9ac36806a2c1102bef5"
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-dicdir=#{lib}/mecab/dic/unidic-extended"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-unidic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic-extended
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic-extended
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end