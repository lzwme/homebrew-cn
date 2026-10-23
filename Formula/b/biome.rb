class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.6.2.tar.gz"
  sha256 "7325c9fef245c55e309bfbf220d0db85d5e9ab5e011f9d20dbd322929e330106"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe40db285b8a42a776e1827816b920e8d8dda266d342e5eeec02a6b73848eb76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9b530a1a8cb8ba1ccaff64a665a6ca9ccf0108aaec42bb60a83f9bc8bae2db1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66de7643a0b7848d01729731f39e4011e42fcdce339ae405595b61b6d860e128"
    sha256 cellar: :any,                 arm64_linux:       "5d980ba93774e9662100d0caf683d38040a314c595a6e3977bf049773dfa6cf8"
    sha256 cellar: :any,                 x86_64_linux:      "2dec1c6dc1d3b5f0cd37cddc5b50541fd2aa23f005817a6380051b95b7a5cad5"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end