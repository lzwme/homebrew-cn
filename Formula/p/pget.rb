class Pget < Formula
  desc "File download client"
  homepage "https://github.com/Code-Hex/pget"
  url "https://ghproxy.com/https://github.com/Code-Hex/pget/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3619c32ed021f22262d19edadc678620e2cf2d69acecf31c044e5dc60899d485"
  license "MIT"
  head "https://github.com/Code-Hex/pget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cba79746eda046084bc76fd4f95874ee7ab7105bbef3b1b5679643cf5d9e6a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e489cab61f88a71e99547c2b78cec91d794924552df02f2985096f1781c6483f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c3c0f4bed551176497e45ac6b4837ab71fbcb7eb63980171df051eeac736563"
    sha256 cellar: :any_skip_relocation, ventura:        "e9bd8347b441b38b076271ff900f8d77bfdc145f85b7e4f8f88fe40c7be965c6"
    sha256 cellar: :any_skip_relocation, monterey:       "00ac25f109a1e31dd76bcbd85d17769a7df53a19872f41043633f6ac6eeddc7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "90c7b271b441ddc0e894a9eb58619a70e9ad8efe2f8aca4cbc5943cb5a1acfe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78b9bd18c11147399094d088dfc16693eb36e30741fb3486d662d0bc9de0c123"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pget"
  end

  test do
    file = "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/homebrew-core/master/README.md"
    system bin/"pget", "-p", "4", file
    assert_predicate testpath/"README.md", :exist?

    assert_match version.to_s, shell_output("#{bin}/pget --help", 1)
  end
end