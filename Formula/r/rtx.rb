class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxrtx"
  url "https:github.comjdxrtxarchiverefstagsv2023.12.35.tar.gz"
  sha256 "fcdf8bb497423f088a9dee205a8ea6d6c0ce8fb7801cc7042727a2a323eafbfa"
  license "MIT"
  head "https:github.comjdxrtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afe49f7077b52d333fa7528c6fc8d5585d6b864c2b3bece7096692774ed8120a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93b28b08c487b00c7baa26a8a4b27bb647d38f04bcaf310fb4c3bfeee0840874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f175ca22f7df269aa32a18f4e96ef982651f2872731a38a162bf9b1fbee5f1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "67615fd892c31a74d34e5ba81109738c639460da49d679a01d8e0d2a97108b49"
    sha256 cellar: :any_skip_relocation, ventura:        "17fc40481f79f31d7aeb3a37928a3d83db09863c12d0b8ac0cefd11500b4c5a8"
    sha256 cellar: :any_skip_relocation, monterey:       "20bbaffcb3609d8e787053c30e05222f1210fbc89934841ea3b2e6937d0ed396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bdd57ca2a10fac340f665bcab19b07bbfa4b74415fcd5b4cec0772bdd3bb30e"
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