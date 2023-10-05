class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.10.0.tar.gz"
  sha256 "5e0a2391b890f1a5b874faf029219d85a6ae1bce9878269779a78857bc598a1e"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "068743e56b1e1bca6245bbb8260af5f12077463322f5191af5ea78ae3606c8ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02575cacab80f36e077e90265b206a8164940ad3e1f3d77bfa091e92720944fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f30cc793d36f9a9276e141149aa57d6911471d5493d86a34f0cb0a40bc93d8c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2e5e7fbc6dcf39a8d9f1e94140247b9748ce847ac40f3ecc9a7b7533e65a017"
    sha256 cellar: :any_skip_relocation, ventura:        "fdda4e5e6c5aeaadcaadbd9352734fb2a994d71efa7f833ce7f407040d45f172"
    sha256 cellar: :any_skip_relocation, monterey:       "481c7421464d2f28733e0b24ba46e21ef0ce212837edb4290dde825de89294d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32398fb2d11a04f979cefa2d9dfb43a2d391514148e2a15be8da3584831250dd"
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