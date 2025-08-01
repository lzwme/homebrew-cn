class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://ghfast.top/https://github.com/XAMPPRocky/tokei/archive/refs/tags/v12.1.2.tar.gz"
  sha256 "81ef14ab8eaa70a68249a299f26f26eba22f342fb8e22fca463b08080f436e50"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/XAMPPRocky/tokei.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "40b48918b40641291a8a9ad1d81bc1da4d4c5a87f9dd427b95716ae8c3d98dab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5cea8923b59fbf212777ab62587234ee3ac0899c959c9d2fad3eca5e5129709"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58c651b034293b8dc4d2dc00c7b2a13d8c6c3c093683ab5e1ebe08a1dc6cf6f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca867ee898e06ea98d3f3012e753ecb6e292160353e187fa62619f86447ca7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b1e487acc3cddaeb578dfab8ec1e8f81fe00834d60d81311b6ca56d2c29f1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "56ec718817e088be8c7aa15872d73df9d54238eacf2e9e8f5e6527f5d548996e"
    sha256 cellar: :any_skip_relocation, ventura:        "ecedf025a74087395440a35c5698d6e35e8831c9da184bee5ecab2d056cf1a0a"
    sha256 cellar: :any_skip_relocation, monterey:       "19c6b4270cf51286adf6e2ddfd2aa45bfa721d52bfe5c8c0792277311a930116"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb4878d9ef7023cba511a2c84635ebf1c428741772ebc5fd139f8a0c258574d4"
    sha256 cellar: :any_skip_relocation, catalina:       "65063af77fcd93f8e3340e48e7cd8db8c8effc00fc93dbf540c9ce60e764329f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "631b4058a3d5387cc82a008413f6072cb890d827a93ac8746b0a36a851a92e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db7e8862a35ed6f09f4c502c45d14e2891fdff54524b1daa728bcd8fdebef2b0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"lib.rs").write <<~RUST
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    RUST
    system bin/"tokei", "lib.rs"
  end
end