class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.15.crate"
  sha256 "7c45bd6d52c7f492b40b68e6bf39c16baf83e2963b2ba7e25075c4e09a580a1f"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b1a1c651c3dfb1e0c8240e4e66cb8a06a5af700aa489f34d666c803c94f89bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd79be411d9a6e10b1650ace83f487564ec332807003f1849e81ebca628647c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2de5dd5d0a878ce3a9669c4ad6cd1f70aaabc05e68f84af03770aa2d881b083f"
    sha256 cellar: :any,                 arm64_linux:   "5e84f289bf8a354388ec6ffa30ad062b4041ab716eab93638723b43a7ac7ef6b"
    sha256 cellar: :any,                 x86_64_linux:  "88e6daef4535f4de64f0fe593f1006265eb080ef41c1626ef883aea76cf13a9d"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match(/Found \d+ model\(s\)/i, shell_output("#{bin}/llmfit search llama"))
  end
end