class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.76.0.crate"
  sha256 "c8cdedc4d6dc9ea0fea3ee801af099c3c0a0247394e8d4e498560bd1c55ef8d6"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "557bbe7df8f4fa362860a84ae9f4e8ffaa7b0901a3c287905910456657dd13cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362102fb432e2401ec09c929e6431a37e6222d02415d383ed53b1e159f151b83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cd44b0135ffd19442e2d656a6f8286e499374d637d09679bf58d5a879a4805c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3a6ed4d4c44057dd25bed72945fa8fe58f9e3dbf04797fdaf54d7484a44b9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6b68a4c93f6784b6a4dceaccedf726974f633ec1faffe94a714b321e5261d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "014b58a7112d560b500d2e300cd73de8ab0c2eb4ed218e40de30417d25f27c07"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end