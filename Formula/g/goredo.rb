class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.su/"
  url "http://www.goredo.cypherpunks.su/download/goredo-2.6.3.tar.zst"
  sha256 "18157db281db53b7c1a90ed23d2d0b847ff2ada2e69725908a89a6f544cee0fd"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.su/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e834196969a125127bf5b60d3b59187ee7c9ae20efdd643729eeaeeeb6fd352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e834196969a125127bf5b60d3b59187ee7c9ae20efdd643729eeaeeeb6fd352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e834196969a125127bf5b60d3b59187ee7c9ae20efdd643729eeaeeeb6fd352"
    sha256 cellar: :any_skip_relocation, sonoma:        "910d377a0883292dd8e219411e89241106c4839e4e63f1042d98e6379b3ec807"
    sha256 cellar: :any_skip_relocation, ventura:       "910d377a0883292dd8e219411e89241106c4839e4e63f1042d98e6379b3ec807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e0dba122529ee34424457beeaabcdcdc24eac19e2f3eb0f5f34d80f5f7739ed"
  end

  depends_on "go" => :build

  conflicts_with "redo", because: "both install `redo` and `redo-*` binaries"

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