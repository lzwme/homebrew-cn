class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.13.crate"
  sha256 "15553b43e6284d3ce062046c33f748169a7ef31cf9ae7bf600493cb5933dd22c"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57dd11a6dd4b9978a9d0282474847e70312b74ede58b800c23e780c30094b5b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0fb562eba1f64d1c273f59418b3861b90e588d17cd0ae42b58b47f5ba567e68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842c7ecbd017e9d761076ab1b7e62b0debe8d81849237188658f075ac4c55290"
    sha256 cellar: :any_skip_relocation, sonoma:        "17590ce2d659ba9a41987cf16cb80215857c98df84e9884604f66ce2d45f8a64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0145c54369683946e79f448fec0f4e0a1325c44a1e03d6dfc420b427e58abe89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f78b596551538254ab8f4bd5d08e0eef9cac9cff940379f5ce318d3b5abe260d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end