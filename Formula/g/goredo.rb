class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-2.5.0.tar.zst"
  sha256 "915c421d743d3e368b62f881f2c7fca078859e2c8dac730ee82fea4998632bb9"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd2283458efd6ab1e616780e656014d727683ffc97015092f5798755406ad05e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70df98a79a7658525f43c3e2e5196410b126b2486a5117489ca066d3b913aaee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "940aa38a9f6cb1df32b92af52e464cf9b6ec9afe5070c9235f685086c58c163d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2df47bcb097cd53e76bd21982350a08e8d84b93f38f258a36a25f803f3cce6e"
    sha256 cellar: :any_skip_relocation, ventura:        "ad5fb2d65bb2bfe87f742c6574780f813ca869c93c348fcc4d7b29b613bf212a"
    sha256 cellar: :any_skip_relocation, monterey:       "1be825b2523e3c6c07ddf2b370eeb9591b42e9947e0a414175bd2d0c16cdfb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b79e957699b579d077bc173c9c2a70c4b88f470df190246fbd9d3714b4a54b7"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"
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
    assert_match "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")

    assert_match version.to_s, shell_output("#{bin}/goredo -version")
  end
end