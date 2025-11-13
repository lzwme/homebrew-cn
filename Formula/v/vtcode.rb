class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.43.6.crate"
  sha256 "79c588826af7dcac0cbad683c30dbdbc23b9000dfcceccf671a20d4d65ba7036"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc2f4f6912c70bd5f2aab6c90e452f6e602ad16cec53036a5ca127236810c2a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4265ecc680985fa9412179a55dabaf97236f4aff9e4d39e94687837b5bea1667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "480546d77bf0c5a9aaf23080fd4606643bd1086fd256a34b78bf68ecfad4c55a"
    sha256 cellar: :any_skip_relocation, sonoma:        "47b8145581f755fc610a67bf6708d5d5237df801db55817b257b136ca0bd500c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0f9da6d9387c3ec8048e43b0829fb840923636c721ad4069addfb6d063aaf77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "283e2dcfa9195d4c8ccfd1a38a0563e9b46f233b444576573de57c8ebd5d9580"
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