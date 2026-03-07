class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "d69678e95ad4f447f6ffcdf88175783c77ebb11b8c0c3806e279b41e3aca8e60"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1af76ca52da79e552f96e9b1b66132bc4f259035c5dd487b68ba858bea47c016"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60cc300e9c863f5d3063cc71e152da76f8e0e4154b1164e2231c983cdcf42bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37ddfe86e5fe090fe7fb5b600ea67079524848f3f36de3b403152b406c947104"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a5e9c7de0796c3b602f444b73c166ce0ea06d12dbc65d879314ffd60c98f32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f663d4cd2048388e6e257b8ddce762ead85c7dc592b7f0b7dec96fabcf75c938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c412a9930376dde39f0bf763950aa2ce1abd84d818899c0c451287257f8e10d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end