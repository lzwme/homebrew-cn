class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/3.1.1.tar.gz"
  sha256 "8c107c1ec31cd544bbf59dc822676ef1966811a13e006aa35ba09546a74c4d9b"
  license "MIT"
  version_scheme 1
  # TODO: Uncomment when default branch is changed from 'master' to 'main'
  # head "https://github.com/go-nv/goenv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "837b6e4bff590588c8aad04799de851220c19b95fe06167ddd6a9bcece81a82c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "837b6e4bff590588c8aad04799de851220c19b95fe06167ddd6a9bcece81a82c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "837b6e4bff590588c8aad04799de851220c19b95fe06167ddd6a9bcece81a82c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f7a26d066ec80953a4036e8abd1625bbe169b4e97a2f10ef1264434ad0ef0f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8088ae118a1dbdd36d3cb55aea571e139d78a9acc42dc2cb11ed670dc48a5c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2578892fc7eb443d45b0807eb977e96425ab6f0afc29cd5624e4c2abe5072def"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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