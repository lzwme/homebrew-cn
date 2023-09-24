class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.31.0.tar.zst"
  sha256 "cfbbbbd5514ca2ae15c07a21327631fda8414a44591e823c3197adf603be5d5c"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "426064dca44bbc50430755a2b06ffe630a7e85fe934e8b9b61dd12f774ec0a10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "426064dca44bbc50430755a2b06ffe630a7e85fe934e8b9b61dd12f774ec0a10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "426064dca44bbc50430755a2b06ffe630a7e85fe934e8b9b61dd12f774ec0a10"
    sha256 cellar: :any_skip_relocation, ventura:        "37ebf3b42958bf543e4466e26f1107ece3f60e8500cd4c76dfd95959d6fe05fd"
    sha256 cellar: :any_skip_relocation, monterey:       "37ebf3b42958bf543e4466e26f1107ece3f60e8500cd4c76dfd95959d6fe05fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ebf3b42958bf543e4466e26f1107ece3f60e8500cd4c76dfd95959d6fe05fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f4779c625bb23912420c0291b68858a61d17fcb47a4479638ae6a483763d3c"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args, "-mod=vendor"
    end

    ENV.prepend_path "PATH", bin
    cd bin do
      system "goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end