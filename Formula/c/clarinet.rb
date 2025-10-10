class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://ghfast.top/https://github.com/hirosystems/clarinet/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "a7e4face46f159b0599300d0b584c9ebf5a5c8c51e7ab9558d6cbca42f155737"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf028aaf9a66a93dcda1d3ccaa085e2182b67b6573466fe0bcc8e6ec6a35d57c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59aad569ef9aba99d3ecaa7bbe8899afeaad59534a620ac6e40f2f4c3c1cd581"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d4753fcd0f44acbbb32c6672f9614d95de48d13e925c0e655d3751ca929be47"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3a0ffd3d297486cee1a26d175aa99a1c7e12832976b0616659f0663f9e1b5d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8096e9637af0ca0312e660b614b5c181c2c9039039521007415b46313b6ec758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "673d5d1ead54efc3b3ab66b35b57e15b36cadf4cb8518241b6e05be73c90e67b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end