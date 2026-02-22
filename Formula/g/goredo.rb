class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "https://goredo.dabase.com/"
  url "https://goredo.dabase.com/download/goredo-2.8.0.tar.zst"
  sha256 "7aaab717697b1c15f24164122f80e769a82a6a157b01a6590365c749d326bd06"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f9d2a3e709efbaadeb550814853f9837ece0092071bd8a3d575c1f0d223214c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f9d2a3e709efbaadeb550814853f9837ece0092071bd8a3d575c1f0d223214c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f9d2a3e709efbaadeb550814853f9837ece0092071bd8a3d575c1f0d223214c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d979f5ba93d0235c34781c18594ca1e828e430587eccd5407bdf2e12a830c60b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfdb027bb5f913d5eaf326ba4fabed0a61b14dc7cea6bea9419480f8c487a747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5780fe19c35cda4fb5c2d884c4154488848f3d843be8734859637501e829d31d"
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