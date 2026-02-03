class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "6985806f1c36a3d2f34ec1a521fce07c2c6928b6e06329fa43c02026cb18c645"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "849b7ce7afac989892204d260636b52e3f082acb91e707721109030877c1bd24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84b70c09ca33386c943029bff3dbde8dccc0b9ae782fdd5e5026f6b265215d65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1a0782d8e50f506eeddb0edd0b376e4a8a837ed51998e2215a31e32c889fe54"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9827b054cbb1880280e4e3745b74c3612f93cc370058eb7c8890428b3203ce1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa59e5e1eb0f801076b621f5f1392f20735687743bffb883e191e2654b95b38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d07f401f9896cf02dcf02027ced9b3ce35eba18006af5fcc0b1badb76f73ec40"
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