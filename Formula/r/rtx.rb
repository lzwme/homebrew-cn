class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxrtx"
  url "https:github.comjdxrtxarchiverefstagsv2023.12.31.tar.gz"
  sha256 "d0b226f16fbfab251ada59fa747b6e18571baa0c21a4edafce85eb66beff7b3f"
  license "MIT"
  head "https:github.comjdxrtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49a9dd627247e6de74b906a1014bca61bc759f460ce39d011d68a934beca294c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ff9393d72a78eb08cafd969bf74129753eee7031b257866a5dbd472821e5018"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b02035d56ea7b103c3d71b45ce604c45c1bc11103ad3cf6380e7e51408b85c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f727bb5ecd9114938b19d9c159b308dae3d9249aa1e32146f15dd021b5c31c4"
    sha256 cellar: :any_skip_relocation, ventura:        "9308a4cd81450a70287f91d6f09b015331fa444602974dc3c2abfe7df4652e21"
    sha256 cellar: :any_skip_relocation, monterey:       "dce30cdc9c88226d04abb2c20926bdbc63574233939247d2a7a11be14a9020ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "419518c384dbbc9185f163f10a05dc13833cda514466156360582dabc65d5b1c"
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