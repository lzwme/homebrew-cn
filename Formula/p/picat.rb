class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat363_src.tar.gz"
  version "3.6.3"
  sha256 "a45ba22f1f25f1523f221ed1938eda962cf5f7d73de68aa33bcba972c0396ba8"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f683d98122de74840ca8a3743d7492ecde19f7c4905a9b47423e8316586f566"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbb424c80b277f830cd7e4471b7b755583be4f3bd373e81d3440778005798d45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a4c6fa93ca895a36df3488cb94468f16296847bb8b4395a8a2163c3bb4e3359"
    sha256 cellar: :any_skip_relocation, sonoma:         "38b4dc2ca63bf4bec63d58e2458d8c771bc0ac6bab9b56d67976d082a377fa56"
    sha256 cellar: :any_skip_relocation, ventura:        "936cce211c4586360e848e17eaf7f9485ba95cdec65bb7e28dc30d7dedd15606"
    sha256 cellar: :any_skip_relocation, monterey:       "a51eb8f58c6643bd11f27738aa37b2e1a101f180e6a9c8625883d4f72f4fa670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd92b3e9fa8988472a5e35ff5839af33d29a66c9fbd9e8a00b852aebcce5c62"
  end

  def install
    makefile = if OS.mac?
      "Makefile.mac64"
    else
      ENV.cxx11
      "Makefile.linux64"
    end
    system "make", "-C", "emu", "-f", makefile
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end