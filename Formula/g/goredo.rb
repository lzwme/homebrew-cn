class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-2.4.0.tar.zst"
  sha256 "a140bf37a34b11506b142ded484b16117501979a3264d9aa45315615b80bfb38"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86f71fda60f5554c82e32e627c803585292894b02137a83c45b0b6314f64994d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc3894af965d2d860569740dc8b6499e4a41bbfbe6df5ad6eed4d26002c551e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0f72997fb621a4960dc8894e224a95b2071dc3c5fadc54e09d8567fe880a13f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b781d82bb7e2f625243e731a20c7a24036131787c97d59671a1547e8659b949c"
    sha256 cellar: :any_skip_relocation, ventura:        "d816d4d494162e8be5b5ef5d651539bc2a0765f35b933d9de7d11cf8c2643025"
    sha256 cellar: :any_skip_relocation, monterey:       "46da3e4eaa492f4c7488e672b1cdd74c3cd2e084ae4f7578b1e6ce1c843b17af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "393ee7068da185f65b409c4d33a9193ee5df4a634457fcc8f8a35d9facfc8915"
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