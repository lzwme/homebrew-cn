class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.6.3.tar.gz"
  sha256 "e7f07c07e59abf76a50c2d56b883ad566e2b5f4a6cf2a1a32fe8c6f0e1baa7ac"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a8d14974f9a2aaac7aa2d152451f476ea2ea6de39c3b3dc9105ec81360a9ea6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64658488f36d9442d28ec7cbdd2093827d49098a2e70ace04475d0c7eb935565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "716b57b1a950a0d3ca592a95f4ad038c20395196fefefdae2dac52cdb9af9af2"
    sha256 cellar: :any,                 arm64_linux:       "872b7e9fff5d50204c2e4231f413604e2b9cd1a6d126db1bfb9d2a8e9fa435e7"
    sha256 cellar: :any,                 x86_64_linux:      "e150cfcf45346410ee2900a4bba8fa790ae10efe334ac4b0a60a265604859c36"
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