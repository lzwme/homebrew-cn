class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.16.tar.gz"
  sha256 "cbd18466e057d6272404345e87147d5ffe9b7984095384756dec38d1da84a76d"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3233d58da77479e276b5d9aa3cf282e69131045f14851e371305a71314ef29d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d92ea47f6ea1ed34df18db6f7547d4363e2b629bd7c734f9ab297bc9ae0211e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020cdf609c72d3f648b2389732e79e304ff401e81f9372edf6ed252362a8f628"
    sha256 cellar: :any_skip_relocation, sonoma:         "206b455be6b82e4cb13a853fa22d4891a6b159b9128a3208d0cf3ea4c9413b47"
    sha256 cellar: :any_skip_relocation, ventura:        "29b7217284d061a4046d21a117dbf4e479e94b0372c30ea5b0eb444fad6e1e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "1d78c24971465a9f7ad3b014b028cc705cf58219a3d0ece297d0d7932d1b213b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97729ea26b6e9b3df70fb0649eac9954d196a3f87c9e8ecfa333cbf1540b7c68"
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