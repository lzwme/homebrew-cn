class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.5.11.tar.gz"
  sha256 "14c19770f88afb4d83e8bb2943a15e9e865b441798c74a049867a3ad33101f0c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cbf725437be1b1bbc3731d40e97476810cfd3e1581114856621d1ae9a9ef916"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06048352089fde336100924f55007d213c6f33d1f54fc3c5eea0ba51c55ac612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ce0dddc9aed0cf0f0137807ae79bc022f839b6cf8a5467f1f8bbb6f22d059b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c5bd929b1c26b7d7afca479a80b0b1615338ac3793f8974173926cb833e7b9c"
    sha256 cellar: :any_skip_relocation, ventura:        "f4f2312964874d3f0da70370c5a3c7e7774c6393aa1e1f1b1f57ed17a8a295cd"
    sha256 cellar: :any_skip_relocation, monterey:       "64613d9a9ec48f97e72c2d7c7ad70e1c26108f595940e54519e8ac4a9b99c1a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7d8a752995f13b3b6bb5d8adde51cebcceb367826911be8e8584520efdf9736"
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