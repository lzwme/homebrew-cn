class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.2.7.tar.gz"
  sha256 "03bbabef8d030f818428beedd0e364fc7f1dcdeb15feb776a44c27e383e962b7"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a554700470ff93b69b6f252e133a376f4be174edeaac239b7565275a0619dd86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2d92890a47d8f5945dcec4eb61252b99f5236d3dd6e781116ec559039c2d6e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cec77fdee223da28a9f072336a03435819936cb4c4281bec30d6dada41ba6c4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a19a3b9fbf3fc7e57a24518c0eebacbe3f91f983e1c4a28b3590471b4d25a60a"
    sha256 cellar: :any_skip_relocation, ventura:        "c91c8ea0ee76abe8ba5b52e684b721e7700bf28de8a65994654fc86fbb99fc67"
    sha256 cellar: :any_skip_relocation, monterey:       "b7e1e89def62f7041c4b10b17b1e8709fd68d5a55e5e41a91eaaffa63b649a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8853257a1ad532d9e7a57e214ca277588c9c5a22eaacc57b7a88e3c327662368"
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