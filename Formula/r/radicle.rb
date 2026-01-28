class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.6.1.tar.gz"
  sha256 "a4806357baf162263002a24fc24660dfed7a43d566a24fc5428b0948d67e2011"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e11422998700c5249fcc8f64455ff641759a1cd54c48e8e8f1247e380ff36db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8cd7a08c94ba66d98f47921a52f8ffe7c07906043ad58b9c5a0efb871565f2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5a94672e5c8b0c9929b278b32b740066f9af2cfa2538dfb930fd79816a6428c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c65df15d763aca75824479d0e904e121614a583007cff87c47d41eb3f7969e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4edae9386a5a06eda3155f6bc4e82b2b6c780761a17824d4b2e317f35a06ab7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96457b9b2e4acd952d08749b0f2937e77630d3789e810a179494d1da3d223866"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  depends_on "openssh"

  uses_from_macos "zlib"

  def install
    ENV["RADICLE_VERSION"] = version.to_s

    %w[radicle-cli radicle-node radicle-remote-helper].each do |bin|
      system "cargo", "install", *std_cargo_args(path: "crates/#{bin}")
    end

    generate_completions_from_executable(bin/"rad", "completion")

    system "asciidoctor", "-b", "manpage", "-d", "manpage", "*.1.adoc"
    man1.install Dir["*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad version")
    assert_match version.to_s, shell_output("#{bin}/radicle-node --version")

    assert_match "Your Radicle DID is", pipe_output("#{bin}/rad auth --alias homebrew --stdin", "homebrew", 0)
    assert_match "\"repos\": 0", shell_output("#{bin}/rad stats")
    system bin/"rad", "ls"

    assert_match "a passphrase is required", shell_output(bin/"radicle-node", 1)
  end
end