class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.65.5.crate"
  sha256 "8a4bce8a966a9b3dbbeaad72de9d8cf39923e415e23cb3935463873c776147a3"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36ffbdbb4f2d9cfe718b5c395180213fa628eca3d050e425eace3cf8ade3a931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d65dba951ac8944ee96f48ea3316e741abea67cd356160cd127fab08ce65d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a8bbc6ca149d3aa642929c306cf73db9b6690f33eab987649e447f7d2792a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc219699d94ee88a474baa07f44f08e6570abac587f4c2dc9c5229c219d022c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4fc246321466ca959209272158f3415ad7e6a50e4c421a656f2138645e4eabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a8657d3fcabe5e33c17f0f65164e6ba308988e8dd93704d94eb05efbbc0802"
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