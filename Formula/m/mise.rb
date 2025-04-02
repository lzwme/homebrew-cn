class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.4.0.tar.gz"
  sha256 "4b62c436053444d3cd958c36c2a027d5429aa2ad084125db844e3487c24d714a"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d95eac26a2769f505104eca776696bb61d87a22b7e414f2305f457856d9ecf82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e87cef053e5336c6258c95acb55eaa6494dd0dc0908880d82a93d072fd58f291"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78bd7bbf89fae5cf5677b1d994c07c458dbe50dc548e5221c9dfff55be93d48b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac4933957522e420290fa8a7c93ab7fc8d20798b8e11e17f0ac56fda51514b74"
    sha256 cellar: :any_skip_relocation, ventura:       "9954813afb44f75d8dbd3f98d738f3abaa1b01f8e771b98a416ff21903f98bc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "850b61bd5ab020ff6548cd33c5dc9acfe6aadb1c47baf716edaf7a0d3536d256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d902908a4bc8201f2a271dc04d724b6dc2cbae6700db1326dd5972dad917f815"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")
  end
end