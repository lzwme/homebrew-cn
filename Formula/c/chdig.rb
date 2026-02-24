class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://ghfast.top/https://github.com/azat/chdig/archive/refs/tags/v26.2.2.tar.gz"
  sha256 "8c6b236fc25289dc447b235b0c71e2a245f6307cad4851fcacb21846c1bedb95"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26ddc922fdbea1a4172312e4fc32050b69d03751ae7308cad16d638f9ef05f55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b07354da583e6b2b46f6160babfd273acd0e711c2587ca4bf28566908e9c15b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "512f4068c8791363c6cb4ffc81d1577325b4effb1c3acc486e4169265ebf7ccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c05490a9a9210971b6a96ac3c206cfb1db58da5d1d2870b54ecd7e913ad9527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d2b1fe8e00e58abb2b83d4873bb0d215ed476615af0293ad9ebfa0d53531185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eac28fc6994826c7db7528add42f4fb1a565a3767b5f6cb8de9fb98b99653511"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end