class EvilHelix < Formula
  desc "Soft fork of the helix editor"
  homepage "https://github.com/usagi-flow/evil-helix"
  url "https://ghfast.top/https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-20250823.tar.gz"
  sha256 "bbfbad0993bb2f114d3f57b18f016d603b201a32c30e6561b6f5d3a4aad9d95b"
  license "MPL-2.0"
  head "https://github.com/usagi-flow/evil-helix.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b88ba2a8e44663f0242fca1189940497c6d2c28205e736058292d8331785c8d8"
    sha256 cellar: :any,                 arm64_sonoma:  "3ca353128f2ac2638994354cdc7edc7c37a3053ab6dbb5b811be404bafb9a040"
    sha256 cellar: :any,                 arm64_ventura: "e90dde6296037c02792859fa919410d271a621ed20d3e67cca953f2896d878d6"
    sha256 cellar: :any,                 sonoma:        "03eea3ad14cf1f1afb152ec5923bd091232ff98747b9053df533ae3214bc94d3"
    sha256 cellar: :any,                 ventura:       "f910f0b4ba0baa174f9d8e972ceef05c02ca3e3788484b364ffdcfb3b4ef6466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb847b0239df09a4c218a92219ef830305c242b110343ee7260e84f26c042f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "073dbdf5d1efafa23dedaa9887767b68ef5d6c81a4d47228746f5c0cd4aff9fd"
  end

  depends_on "rust" => :build

  conflicts_with "helix", because: "both install `hx` binaries"
  conflicts_with "hex", because: "both install `hx` binaries"

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    file = "https://ghfast.top/https://raw.githubusercontent.com/usagi-flow/evil-helix/refs/tags/release-#{version}/Cargo.toml"
    version = shell_output("curl #{file}")&.gsub!(/.0$/i, "")
    assert_match version.to_s, shell_output("#{bin}/hx --version")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end