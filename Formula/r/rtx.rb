class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxrtx"
  url "https:github.comjdxrtxarchiverefstagsv2023.12.38.tar.gz"
  sha256 "397c3723753343d2e4075139885393357877afa88486c047de1ff5993eb6d897"
  license "MIT"
  head "https:github.comjdxrtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77c7db4ddcb9cbdfb873af306abbe0bb33cd00af62901c555f7d66609f964511"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8164ed4cd6efc4de73c35ab0b3ffeecbcdb0146b2ab7664d8d0614aa8d36571a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8197a2dc91948b3158c3437379115b919ad097f1bf7ade9fdeb6e2afdb560b5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "789d1d3df1a03a17e854e9b276764a087556f0833dd811989f9c96bfb16f1caa"
    sha256 cellar: :any_skip_relocation, ventura:        "609192bdfd9de9fdd4f732064906d682ed7c9a154560ccc19e3d7a6f1292ba81"
    sha256 cellar: :any_skip_relocation, monterey:       "b0f232ac5486922446305b4f83ed51d39c6c2f6cd0195288d260b193c1263f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "960c14cb69bb1f84555fd1db7294fca0309861df5c8aa16e9a23457b66bf07e0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manman1rtx.1"
    generate_completions_from_executable(bin"rtx", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""rtx-activate.fish").write <<~EOS
      if [ "$RTX_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}rtx activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, rtx will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}rtx exec nodejs@18.13.0 -- node -v")
  end
end