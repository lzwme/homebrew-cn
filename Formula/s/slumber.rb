class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://ghfast.top/https://github.com/LucasPickering/slumber/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "8450d1da2628d36a880b2d2474fc7e8790ae699fe5ce7a4ebdcef398fa65807b"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "302ce62cc1e52d271f69cef9abfac2d9b9d6f681d08f5bd11e691a249e25c4a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc37cc0f13c9b8d43f327f9a8a7e20d5c29456823b93d19ec18fb223cf8c0f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a63ee4b8977dff7b3967ba98225d61f26ad86799ef4a611b11f78ed17a1c7291"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9de025a2b2e907b3b95b7f07713bec27a4e0f9765678f4d8daa98dea27b8e8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6233424bdbe8d03711b70c966120e7f857b165110cada43e04717c3f1aea998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79a6d61e5a5087a630f428dd61fe2a84a6a1cf6e47ae383fec76464e2914e2e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end