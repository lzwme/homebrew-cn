class Ent < Formula
  desc "Pseudorandom number sequence test program"
  homepage "https://www.fourmilab.ch/random/"
  # This tarball is versioned and smaller, though non-official
  url "https://ghfast.top/https://github.com/psm14/ent/archive/refs/tags/1.0.tar.gz"
  sha256 "6316b9956f2e0cc39f2b934f3c53019eafe2715316c260fd5c1e5ef4523ae520"
  # Official git has added "CC-BY-SA-4.0" license but this is not included in current release
  # Ref: https://github.com/Fourmilab/ent_random_sequence_tester/blob/master/LICENSE.md
  license :public_domain

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b575b8008e74224742c5e78c22a496ee80c8a7efa3c62ba1856472f786d86d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f95e748a208f421f6d85b9e5445139c9f688f277ce72fbaed93449322b96abef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9870a5d35b78ac2198a5f793e861dacb1961226df38d8d14dc3538a2f36775b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "711e6b4a66e2ca5ecb20bf7bdc9f74d2b8b8c30e9b5e78bd5f2b24717fc5c008"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ae99ed1f191f24e6a66bc3bbe668af5d0bf43437fe28a4b58b6b96643845b78"
    sha256 cellar: :any_skip_relocation, sonoma:         "a61eafbc7b7629e3b4b2af2a14f7c08ee4374940f84aa07b76d26e730b701afb"
    sha256 cellar: :any_skip_relocation, ventura:        "eff4c785445db5ab72694aee597e36b1a42bff98520f8a9eef4955f513da620f"
    sha256 cellar: :any_skip_relocation, monterey:       "03a87ece9769a8a63a5c88fd457a93665f6ec30e0fafb796ec65aa931e2d2a51"
    sha256 cellar: :any_skip_relocation, big_sur:        "7023711763240801b061fa09d5a721286b650edbd01188f54d41c070317e6106"
    sha256 cellar: :any_skip_relocation, catalina:       "e51a453d227894a84db498d75bac3205f82fdd3b104b176fa691cb8ae864a14a"
    sha256 cellar: :any_skip_relocation, mojave:         "c2a9cd4a124a37767cc35a683aad913a92e712627c5ff00c43db06dbab38909f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "61cac8b0bcf0c511e6c77760cc9441ec7b4d981392f98d37bd8a40fd281620df"
    sha256 cellar: :any_skip_relocation, sierra:         "9f20aba355ecd3310d5e4cd425fe69d88e20e9e1bc128a4b6a97c5d98a828135"
    sha256 cellar: :any_skip_relocation, el_capitan:     "f5244a065b7aafe3ba60077de0072e9b5d231a7fd1eb348cd7f6583a69a08ad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ed90a387153d2eef621120f0fdd2ca1cdd77d5013ebfbe748ff1b824a2075592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2473992bc5d574c4fff2dafdc65e23e72c6661fab3b939d6a853a98b45538e4e"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "ent"

    # Used in the below test
    prefix.install "entest.mas", "entitle.gif"
  end

  test do
    # Adapted from the test in the Makefile and entest.bat
    system "#{bin}/ent #{prefix}/entitle.gif > entest.bak"
    # The single > here was also in entest.bat
    system "#{bin}/ent -c #{prefix}/entitle.gif > entest.bak"
    system "#{bin}/ent -fc #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -b #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -bc #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -t #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -ct #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -ft #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -bt #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -bct #{prefix}/entitle.gif >> entest.bak"
    system "diff", "entest.bak", "#{prefix}/entest.mas"
  end
end