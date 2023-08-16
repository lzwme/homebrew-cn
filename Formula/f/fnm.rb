class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://ghproxy.com/https://github.com/Schniz/fnm/archive/v1.35.0.tar.gz"
  sha256 "31b29e4534f17240ae576c9b726498bf551f1c14b3a0fb3ecc9f4aa95843d27a"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41b0b4de195053d7e0783a450f8dd39d5d72602df49add9476bdd8492323b1b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc3e5e4fa5564f86632cd597221363f9a17f1e22b74aca03a91bcfc4d2779629"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "071a1fd257337f5117e250aa6d717c0ae0a6068b45e39058f5ed1ea1c270641c"
    sha256 cellar: :any_skip_relocation, ventura:        "2c307a1b9300d457839ea51fe2e6737a022c973923b2a159b2066ae0f188ac91"
    sha256 cellar: :any_skip_relocation, monterey:       "ed23f0955e804b4730aa9c88bd0294514e7c9638e8e3be4e5f1c4acf90f2a294"
    sha256 cellar: :any_skip_relocation, big_sur:        "5995db0e7d6fa3f99072534e402561e6270114ba521a6f81d87698640507792b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "880434fe4224787d632b52126de18bfbb3953ba5f10f1b62ed6c2b1a1f7c39ac"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  # Patch the completion generation per clap v4 upgrade
  # upstream PR ref, https://github.com/Schniz/fnm/pull/1010
  patch do
    url "https://github.com/Schniz/fnm/commit/85625e64d596c6fc5d1ff20d4af54d43c2561b4b.patch?full_index=1"
    sha256 "30c30985ea14f6c7124e7035cb193b4280a9537a7627ea45f3efd2b0baf327b2"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end