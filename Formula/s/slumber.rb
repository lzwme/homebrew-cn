class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://ghfast.top/https://github.com/LucasPickering/slumber/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "6be559a499be09b5db22d5a6b3401a6592412d2c938d1a9ce8bd8c7cd40648c7"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "babee900bfdc4fe40664eed184481fdf1d97dfdb637c0bdcca18f91034147b64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a971992af6ad51ce4b71b460fbd07f2d12585dcc1a58d196345f4df2397a1d8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9eb43e4c0767e8a6dab360f1348ff5bb21353305a45d56582f271e3186855333"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ddd1e2847439e2a23fc64dc6153f017acbc1da7281f27744c9887cabc8bf30"
    sha256 cellar: :any_skip_relocation, ventura:       "822a3ba5c4b0a10f55e452954e11d2c73dae63b3b5aa3a3881a9a41ce8c5a27b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de57fc31a97425a1ee8d1d81a71c7d34773a52cf4a6304e442f934c1951c353a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54e6a113dd99dd0397f766d47e126e9e19c6faf3ff5e1315055944ad53827137"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      # For basic usage info, see:
      # https://slumber.lucaspickering.me/getting_started.html
      # For all collection options, see:
      # https://slumber.lucaspickering.me/api/request_collection/index.html

      name: My Collection

      # Profiles are groups of data you can easily switch between. A common usage is
      # to define profiles for various environments of a REST service
      profiles:
        example:
          name: Example Profile
          data:
            host: https://httpbin.org
    YAML
  end
end