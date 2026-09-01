class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.81.4.tar.gz"
  sha256 "d765fdfaa58a98c01d97f2d6668d487d5906b05eb253952ad5f19bd369847b94"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38bf46be21f53bb61cbb9e6abb55d0ae6e8407ab8ba4c4574b8edec447a06fc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "320cb29d43b59b6578aa2828694327c0badcd53bc3bea54508c8e81c7f4895d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "832860546deda7d0902635ef520d67eb015e8b37abfe8f2a99c8205ea786d492"
    sha256 cellar: :any,                 arm64_linux:   "6d148d1eb63aabb672c857cfd40b8c2957228a92a2801c4dce383a4a664e4eda"
    sha256 cellar: :any,                 x86_64_linux:  "6076e2c40fa502b81b3fe6e4c97266bb4b93fb3745b5fb6462fa68c655366e75"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update()?;",
              'eprintln!("Please update jcode using: brew upgrade jcode");'

    system "cargo", "install", *std_cargo_args
    rm bin/"test_api"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcode --version")
    assert_match "Please update jcode using: brew upgrade jcode", shell_output("#{bin}/jcode update 2>&1")

    system bin/"jcode-harness", "--cwd", testpath
    assert_match "alpha2", (testpath/"sample.txt").read
  end
end