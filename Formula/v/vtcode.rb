class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.143.0.crate"
  sha256 "b8ade2343759e455d7cde3dae05fbe4ffa66af140c46eb3ec8204435ca7ce1a6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99892070a1281c9f13c5870079d8f92e0118fa53d57dc2a0e6d793383e8adbf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18568394a769b5b1cd141400343378307b9c931918c5f5b0fccedde7fd8d4519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44b1f75082a04dca1511c6cc6839c6c056797b5a911f215cade1135d2f586d14"
    sha256 cellar: :any_skip_relocation, sonoma:        "46c4423013991abcca1cd491ff1266edf5bffe2961e1641284f55930f708d4bc"
    sha256 cellar: :any,                 arm64_linux:   "bf06279d0bc2c9e02cca874d6c57b6510548636da065e15f13b2c95406fe209f"
    sha256 cellar: :any,                 x86_64_linux:  "73d9d0c1e200e8d0fb8657fd57360f0ca80518c8df914c881184fd85f37749bc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end