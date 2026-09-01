class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/3.1.5.tar.gz"
  sha256 "5d07fea064fd237b6a8ce1bfbc287af5f93f721c657643c205baacb2713788da"
  license "MIT"
  version_scheme 1
  # TODO: Uncomment when default branch is changed from 'master' to 'main'
  # head "https://github.com/go-nv/goenv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f2767a2a94cddbe7298ffd85bbd2fb0c377c7f8eb213a9c18e560bdf6534c45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f2767a2a94cddbe7298ffd85bbd2fb0c377c7f8eb213a9c18e560bdf6534c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f2767a2a94cddbe7298ffd85bbd2fb0c377c7f8eb213a9c18e560bdf6534c45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2e4fdbeb82acf43d514520e84426d3b1ba80ec548aa4196e08b33bb26f51b45"
    sha256 cellar: :any,                 x86_64_linux:  "a3151243b69b0678969007719220a039b1dc06015c48b26785e6bf2d00f2a8b3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap&.user || "homebrew"}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"goenv")
  end

  def caveats
    <<~EOS
      If you are upgrading from goenv v2, you may need to remove the stale shim:
        rm -f "${GOENV_ROOT:-$HOME/.goenv}/shims/goenv"
    EOS
  end

  test do
    ENV["GOENV_ROOT"] = testpath/".goenv"

    output = shell_output("#{bin}/goenv root")
    assert_equal testpath/".goenv", Pathname(output.chomp)
  end
end