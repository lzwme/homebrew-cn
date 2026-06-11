class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://ghfast.top/https://github.com/mimblewimble/grin/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "1369b9ef186ff136c4738cc48361999369edb437c262a9176bcb943bd935befa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66587fb4f93043d90ade2946c28f37d2499506d792ee06907ce24cd3bf6f0a9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66dd945d254ef4186de6a3ffe4078f0a449c5986ad3f586bffae0dc16e87dda4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8102b8d5bd86e3a4daa7c1a83f972f8f10495b1feb7f231b9e68c1f1a79824be"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd9d8731d228e3835f6b21b8717dd433d25d052296c5f02b22a5bba3d499f44e"
    sha256 cellar: :any,                 arm64_linux:   "f40ac8aae4b77030c63fe94cd5f1cd173e74ceb3636abf838ecbb7ac756193e1"
    sha256 cellar: :any,                 x86_64_linux:  "23f4c0d470795634526c8fe4879023fd2a027e6222ac3b54005b1aca4ba75785"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_path_exists testpath/"grin-server.toml"
  end
end