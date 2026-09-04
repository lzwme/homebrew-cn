class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://ghfast.top/https://github.com/1jehuang/jcode/archive/refs/tags/v0.81.5.tar.gz"
  sha256 "48489f235e2a9119c7fa0616a5771959495f64b9b444db86d899eab2b932735c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5159684facfab070aaf0915a26dd4ebaec1a32e0aeeb7c13912cf86c30127a0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ba69dedecac76db7988089434d695196204f8fe74f911e6776abfc2181c301f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc8b362d9bfbf7411e273f33720edbd54cd8a85ab429b48ca615e910fd538e32"
    sha256 cellar: :any,                 arm64_linux:   "6a989ea1fd1bd3064f4dcd7edfbe6869d83e75d34921de902f5c04ac3fe08895"
    sha256 cellar: :any,                 x86_64_linux:  "f5f1e4d77676c5be5de500da63e3db80ce95849c262b086beda61a41d9b9287a"
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