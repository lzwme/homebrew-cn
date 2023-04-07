class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://ghproxy.com/https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.13.8.tar.gz"
  sha256 "88a312fc35fffb6e5d99e35322ecde1e71495155dd7c1b0b5efcd94810ad5ae0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0c07388262fe8cb7b3642cfaf7b002b4821954ccc7db8818133b9db17ef3231"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "366b40dd7b7511cc0846761879c2a5cfe9a5d5e8633dc70531f1915d974b0943"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac7af79cb51d22dc2e073c223c81815690b09bc4523d9c2a6948970d67e81816"
    sha256 cellar: :any_skip_relocation, ventura:        "66546d1b24c326f4514392cbe619050486ab2e0b7419a209fdc04c8f24dd47f9"
    sha256 cellar: :any_skip_relocation, monterey:       "8e12b60f9ceb9f460fc8b50c4e6f7eae9c8d586e195864b0425d7da5a6556d9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c5b55085d35b16041b2b0e565528c939b143a0839a58f1e17b5e0261cd8ee5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6250d244b6650baad525806ef17a66d57577a8afa10c19da6bb8887df540d25a"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 1)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end