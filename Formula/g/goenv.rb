class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/3.2.1.tar.gz"
  sha256 "29030c8362c6f07ada11244f4e0926a170aa9631a33c4d08f534ddd4f72ca58f"
  license "MIT"
  version_scheme 1
  # TODO: Uncomment when default branch is changed from 'master' to 'main'
  # head "https://github.com/go-nv/goenv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f4802bfb68a686daabd327a17df9c35e37db15d4aaaee5b977066664e3b7614"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f4802bfb68a686daabd327a17df9c35e37db15d4aaaee5b977066664e3b7614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f4802bfb68a686daabd327a17df9c35e37db15d4aaaee5b977066664e3b7614"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "65899c1d056dd9e3a228d3a97774f6f559f48ee118157a642dbf12cf967879df"
    sha256 cellar: :any,                 x86_64_linux:      "da9bf96a272b9de816806300f8050f9ef2bda832e170161fab366f3b2288c733"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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