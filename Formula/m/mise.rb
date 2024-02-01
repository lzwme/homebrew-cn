class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.35.tar.gz"
  sha256 "4d05e24d34bc195c1c7207ba2ab29f1ba1674453275bc97a3a8ec3f0af94f3c7"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdefbff99206dfbf5368180d9b2362dc86ef90488f94b49f8bfb27826570e498"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b28f702d2d5a2b7c483d2795e6ff7a2ac7aa30450ed1d04287d4c737ce9c28e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e1bd1a3eb05ecf596001986859de4799b341148f330201dedf142f9fedcd342"
    sha256 cellar: :any_skip_relocation, sonoma:         "3679e9dd4858a6db037e661675c94c78a4887f7a16e87ce3bf036a025a31288e"
    sha256 cellar: :any_skip_relocation, ventura:        "e35e9ce068fd32d881dae5073e8b8df313e786bbc5d134272cf601d606e7e256"
    sha256 cellar: :any_skip_relocation, monterey:       "db580389b42bc5ef4cb1b40c7f16806412397e59ce344a1fe20e61e9a98bf342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70420266899341e6906389c538a028e6e3967e211c8b86eb00d5ca13b319e678"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}mise exec nodejs@18.13.0 -- node -v")
  end
end