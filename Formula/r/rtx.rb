class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.21.tar.gz"
  sha256 "26b662ff215c130610f67f764f01d66d7e95f8edef7168fcd94b1d8d5de5c04f"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de37de1cd63eb5195d7c94e3102963c02e6aae4d69e4c968110404b49cd91d1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "248be6b6431d554e8ed74b0ba16dd7d6f7ead81646b263bdc2db544f9c47510e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2635293a1239cab9dd442b21ddc93f265d1ac73aac92172f96b1cc641642650d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cf1cf10114b4bc1a0caf679a5838d172cf85e7f28dd62b282f6a513686c1439"
    sha256 cellar: :any_skip_relocation, ventura:        "a68b430b7f84e5a169b4fd00d33d015b956ac23454a2a95e4f80023f1944e2be"
    sha256 cellar: :any_skip_relocation, monterey:       "3e4611da5d4670562b6365df82befc7d53f669b354640375ca029400a732ce4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99356b6c366b45509831b4f111372b753b2ff43599b74747b96959c1b3f3881e"
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