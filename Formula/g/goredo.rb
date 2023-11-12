class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-2.3.0.tar.zst"
  sha256 "8b8de2bc9d8339279b87ba91a585937d3c90a3f3c5b7349725c8986cecbc7b8b"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56d3b076b682622a180d04e16c91a08908c2f6c7fcff74a70e5bdf6dd83dbf7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e2e582ffbd73689a51cef63ed852b4760460e3f9fe873ada002bfe473ff0885"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "766e4d417e2e0a92525b83c18080ce10619961b87e48e3809a36096cb90a60f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b81872a7fb472e2a43889f33b1882f2420b120eb98f3787374d0b50959667df4"
    sha256 cellar: :any_skip_relocation, ventura:        "ae312dd2bbddbd677750ff2029bd1d52373b705036d0f75dc9354c3bfeb37684"
    sha256 cellar: :any_skip_relocation, monterey:       "4f1d7d167d099d48d08decd3027ba8ae06b964117d4588cb235c41e213cb6b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7898464ef169cbf73b56c24d6a9d939edab38a117ac3cccc91c1bda7b2926b32"
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