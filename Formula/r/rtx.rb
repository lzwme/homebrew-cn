class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.3.tar.gz"
  sha256 "ce5f75e29d5c506695070510fdd21579fd79c00a58bf9d306994754c81e3841b"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bac459d09fc892b42fcdc26e19b9351cad42c61c8230acccd87325787fb07380"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcffd32fcfa4b3c0038af47dfbe10751e73e889edfff786f8eae8d67df728672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3a9e9155cd8878f9484cfd18c9b796815de540f6f9c64007a9c440946ef64ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "3633809b74f72b2defca04d253af2edd33866652455e7e06e24b5633444c2ce1"
    sha256 cellar: :any_skip_relocation, ventura:        "a01baad64f532c6c5b5ef98b4586455f66d749cb09de726238f67a54908e6a2c"
    sha256 cellar: :any_skip_relocation, monterey:       "9d7eacd83a49dd31a51d47b36e6624fcfac26612cb151c006f77075b1506e992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20d2c387640279ff2016da30c7d9437663743ff8a7f4e9b43305243b4e72ae79"
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