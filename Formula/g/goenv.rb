class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/3.1.2.tar.gz"
  sha256 "9edafa9c0e5a2245c62caaa7bf7d7c3bb9291991f0ba55f60f3a724367c04ca0"
  license "MIT"
  version_scheme 1
  # TODO: Uncomment when default branch is changed from 'master' to 'main'
  # head "https://github.com/go-nv/goenv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e673d0c6a6231481b4543ce7981a871665e17bd08374de7fa9bf2aec66570082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e673d0c6a6231481b4543ce7981a871665e17bd08374de7fa9bf2aec66570082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e673d0c6a6231481b4543ce7981a871665e17bd08374de7fa9bf2aec66570082"
    sha256 cellar: :any_skip_relocation, sonoma:        "959352abfbb0512053e1d666cbdd7d82ddb18b9245c819cec0afaf5db268e954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df764c1551b36710f461992c59a1bd63b5e592f6cf0825bf833ef45e137690f5"
    sha256 cellar: :any,                 x86_64_linux:  "2de4a3d47019f20b56adc444d74a3c4c0fc3c25501542dfa739682583b93ecee"
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