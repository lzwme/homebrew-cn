class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.35.7.tar.gz"
  sha256 "e3230e2143745d885962e8bc17aed94c13cd29bdc022ed27ab07da782ba5395f"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd00a4251796f45b6e354c2131f56543a4e1e5be6aa46a2edacea147c59cd4a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d432be7410f5e72e52abec586056b7873a09f381403843c702667807d859116"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdf5761dada6f129df11140c4093304876194b3a6222be80798a535afc6bae1a"
    sha256 cellar: :any_skip_relocation, ventura:        "b869c90fb1078f9aeaf954a2b0414010ff4e9d34572884a96c82bd0fbcb180db"
    sha256 cellar: :any_skip_relocation, monterey:       "4060b101e8688db33dffced209a3e94256af7a57fcb187b344e8ecd31ce732de"
    sha256 cellar: :any_skip_relocation, big_sur:        "f803f8e9d721a8351c4744afe03897ce13beca23231d2727e17b4d9296a56ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c668f6ccd1069083a37a2ed465cf5ebfb1bece3d9b108dd8176c6214bbf7813a"
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