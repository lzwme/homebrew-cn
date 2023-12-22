class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxrtx"
  url "https:github.comjdxrtxarchiverefstagsv2023.12.34.tar.gz"
  sha256 "691a7a749557b10fd3f5cac0a05af7b222627f507e2b114095048f215d9a0716"
  license "MIT"
  head "https:github.comjdxrtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98367a77479b76f3df4e07615411caf09d95869e331ad3814dd127eb11191dd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f4adf2df6686862a0dc19fa9b48beebc5850c03c10b846abdbad8f50263454a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4efe1cdc2774458b4fe858ca149a46baddd699434e4fd37b5a04fca74b7095db"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a2922acc0917f300634a8a1e6bbc2aca0ac226c6dffddb85a784fd80f6ef965"
    sha256 cellar: :any_skip_relocation, ventura:        "ec4ca8117c72e800a085781a61f63a653943cfde444b6dd66cae993383945998"
    sha256 cellar: :any_skip_relocation, monterey:       "ccea6ef4d91d5c3d58b1355b47e984f625c450ae305dc9a5209b0251a7cc81de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918fa374b883d6ee68596bb6f066956b0ac3120a7f1f0088d73d72798a292d7c"
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