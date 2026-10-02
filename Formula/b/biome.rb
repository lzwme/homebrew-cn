class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.15.tar.gz"
  sha256 "0212a8f9e351e2d47580cf8371948dd477ceb01e0fef1a65f81061a2a4a39039"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4a114410bae6d9da2d891ccd414ab5076eb0ca3aaa767b2f45c19a8a2fd0d8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8aa06c191178247e15f9a2f821fa95c002bff7dbb1d4967d17a2a549dfcabadc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c80fa1ec83e73bcdd25e78cdc0eb1a8e1acc031b2ed746fc63226fecdc0f325c"
    sha256 cellar: :any,                 arm64_linux:       "dae57de0ce7f06cf6e10b1d3e6c19ca85e17d5e125c4d889264bc7b7d1a51a6e"
    sha256 cellar: :any,                 x86_64_linux:      "cb0fbbdaf36e32dcb43f3bba52549be23a9d38987233c65f3074a850444d75c4"
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