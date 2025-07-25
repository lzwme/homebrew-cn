class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://ghfast.top/https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.114.tar.gz"
  sha256 "e96da6975254a9372807dedead4e98618757ee5965acd91d4b60368b2e684d20"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6c9e80ab4a6cc40f9081a655d79e97705548034b31444909ed445eb7cf4e314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "231bd4410fe0d905871507c676ed1ab77d8a4df56ac485c93f714a16f16f6c39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "581ee357a89b734b19715dca900f8d3ff1e71b3ffd97d4e297b63cb931dee413"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad6536ba104110370fe9f6c4332fea29a57f7a865b90c7186a9d326b2938256"
    sha256 cellar: :any_skip_relocation, ventura:       "2f841cdb85984a3935b8bf1ca62768f7d8c0b408936c2fd64bc8c4368993eb2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2506cd24165c92a3ab1d942ec57eed6ea012aca398ca4650803e6c02292d740c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed02fe8ebd53047446070d241343e9f3111e48672e8d11174178d2d2b5654034"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end