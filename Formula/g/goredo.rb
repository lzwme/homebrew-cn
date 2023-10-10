class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-2.1.0.tar.zst"
  sha256 "8ad85be2088a380d1e825dc2bb3f09cf4dc1c09ed3496ba7f0ef28615aeb1137"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80b5cdbf2b22d49c6c7700cd463ad573d5f058177546e2b76b3d5217f7f1e402"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59247e3d3e39982183393b01bb2e3a0460d2d0a09325e7d7a469efa14e9bf770"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98a8175bf5f262dd161280e599a8821187877124c9c2cb4ed7fc24b5d8043eae"
    sha256 cellar: :any_skip_relocation, sonoma:         "547d3ee54ae7df84f91287e3d2770030a983f0a508d1f90bd4a47dc999e3499c"
    sha256 cellar: :any_skip_relocation, ventura:        "9ef634ddbf2ac8bc5b88adbebb5242e879303c6a2dfd895d063d63006d31406c"
    sha256 cellar: :any_skip_relocation, monterey:       "05f2f520ffc6cf796a19803951f57a89fc217ea871ecfa05f18b00864bc54275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fede027caa759539259132fc46508937f146677b6672c491f8a8113324cb6f3"
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