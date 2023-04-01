class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.10.tar.gz"
  sha256 "bd82e00330a37644ce9fb02684986446a2dcd3ee8db919a66ac3eec4f4aaacd8"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b7512c73c4326adac49c1c0f880f386bd035ce26565ffcb45f88bd5937a500e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fa736057086c51669e7ee5abb7869c6b831542b519dc4d9c1fd132969b661ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec1a08ca5381466e4cba2641dc60adc96076fe11c39a208db7c6b954feba060d"
    sha256 cellar: :any_skip_relocation, ventura:        "b836c70d6ec39095875b7f886c3d7b5489957ded4c09d3da5ad938bb99620d64"
    sha256 cellar: :any_skip_relocation, monterey:       "0c71999e2840098161352e4e15a6aee6f3ef23dac2a560487bfc91761de1f29a"
    sha256 cellar: :any_skip_relocation, big_sur:        "adff81260d43aff0e17d2f158a0000856ea269753018eada8837d0b599837a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "130995349f9fc053741b5c741c38d4dba2c6cb194923b856090a30665f6840c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end