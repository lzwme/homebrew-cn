class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/3.1.7.tar.gz"
  sha256 "69c65764e3e3f320656a740e2bb4a8a17b433ed46d0c6bbc4c2afb4914e19f75"
  license "MIT"
  version_scheme 1
  # TODO: Uncomment when default branch is changed from 'master' to 'main'
  # head "https://github.com/go-nv/goenv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6f44d8010a81999c105c3ddef4c79a16d9563be778628567c2acd7e0ac03bce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6f44d8010a81999c105c3ddef4c79a16d9563be778628567c2acd7e0ac03bce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6f44d8010a81999c105c3ddef4c79a16d9563be778628567c2acd7e0ac03bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "009ea725c7be86acfd1e5a61e7e93ee2bc3285a427d256163c4a165291a7c7df"
    sha256 cellar: :any,                 x86_64_linux:  "5a27824ddd25cbe6a3341945c1eaf3a9085439457e9edb0b516af6ec73a79a00"
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