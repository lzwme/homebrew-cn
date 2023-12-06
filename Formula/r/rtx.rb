class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.8.tar.gz"
  sha256 "ce638f38821952bf3e339a68ca8d1e13c34037bd7e442f531b9a5f6c3c442e48"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "887313d801e7c441c4004c3aaa0c24fc8c875671d86518b6a8a52461d12efd16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae54b989d2af382eb670453be06cd800c7659ba6ff3f2b950babde4df248ea2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "540862afd81e54d1f4c58ce35c25d8b00d37e675a561eb53fe265b8e25a34a04"
    sha256 cellar: :any_skip_relocation, sonoma:         "76b55536e845219755cfb6655b20af1a3f9e04de73be701d510fc62e4a76c46a"
    sha256 cellar: :any_skip_relocation, ventura:        "327a61c74cf4d4105152deaadee4c956295ff18cc6115d6dcab77a203797f36d"
    sha256 cellar: :any_skip_relocation, monterey:       "5d1645f3340b24f2820d0bfa90825f56650bd34ea8c047ac202ae8e4cbc283a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00370e7b5e8c73439fb754a39aef5fe4bc4c5a4948edbc7819d95b8038521050"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end