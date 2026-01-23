class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "574958889fec42374462135206965bdb1dd7caab000090dc18f508f7306d1ece"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc1eb45202306b9101edb449af148ea55cba1ad017063c196a7d7f4bacfe89ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd56a19ffba47539d89a900936ab0950b20b6526a8b34ed92ff735d17371b327"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7e265f0b04f1a45416131394e2e927523b60c0c955930b67810c3d0c27ff6d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "05808f0abdaf01f089322feb76b216e551d5ee9585d883a8aa1aeb92ec9f072e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae410a0adeeb65a95133f0e2ed62d56776cdeaf63214d8da8102519e4dcf1b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6102247db98b7cd594e5412cd9da7425087aacc0aecd63ef37765e5ee20b36a3"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", "--features", "cli", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end