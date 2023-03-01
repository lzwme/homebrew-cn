class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://ghproxy.com/https://github.com/cantino/mcfly/archive/v0.7.1.tar.gz"
  sha256 "75bb4e64bcfe339181baadb8adc1ec47001d3e0fb5d20c6e13ec3e071076d4dd"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa820545b749cafbd43b55a352cbde01c547208cbcf54af175427891d4a6f48a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db4d5dd16e36ce2fdcaa29cc70fb0d4eb6d9cf4dd62f11c0d48b58c5b0f9d999"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "358ad877dc790c5cbd55737e6a5aba2b51ae0a067a2be98b598e494e3c73465b"
    sha256 cellar: :any_skip_relocation, ventura:        "f15782845fcf66c5b4f190dc0dcef7606ab32b6ea1382d61d72bd3b101e61367"
    sha256 cellar: :any_skip_relocation, monterey:       "29275577177be5f89af9179d6fa47b1c4b9b180173080be928ac1386312f101a"
    sha256 cellar: :any_skip_relocation, big_sur:        "aec022619e09a10a0f1feea4ec67d163976f9f5a2e703581d1e62bec488ebef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a84fb6f4d7479f37925849ba6811811341bbbac5ea9db601955fa661dd051f9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end