class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.11.4.tar.gz"
  sha256 "b13e94985263fe5061dbf9d704eabc3eb073d419b7941b67fba9667cfd5d0309"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b603f137cd8380a35f220ad3db8ed1cc8dde7db8294255023a355f3e3115fed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ead75a08b3e2e0c11ba7e25e2e8cd69e2bd778fa8900e9029374a6f44769cf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c84068895f6f4a32cc7f22c56bdfebede269b7a392ca8cbd2124aa7fccde13b"
    sha256 cellar: :any_skip_relocation, sonoma:         "868a0d5d65457c8e8e8d986cb0c3ab36f1a279faa37946334a9598a5ffdf1d91"
    sha256 cellar: :any_skip_relocation, ventura:        "4a2b0338edfb0264e071f9e41acb34d9a354a428daa2e3e7a738d3e8282373c6"
    sha256 cellar: :any_skip_relocation, monterey:       "b69dc932660138727cd4f97df8d91364530cc44a364c78b1699bcf134fc017e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd65fa48d953c7be389e4b5c781ed0e43130b993ea93155cf69a8dac639c970"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end