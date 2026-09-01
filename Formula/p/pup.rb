class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.16.1/pup_1.16.1_source.tar.gz"
  sha256 "f87cec6e0d51c7a591162f8c3360ec8c3e0b364bb2d9185d59245e4ef7c638da"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0bd14346dfc2511939e8df13a61011f00ea248d8b89021e6cb02ee6d609a6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4db9e08659bb19cda8af7580a16bdc9b20c24bfff31d76a3c8a81d4ae34b43b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5aac3a7dd562fa7887c78543cf83e095f86205cd9fbeaff3df5871a62b2c31"
    sha256 cellar: :any,                 arm64_linux:   "17012edf922084fc6cf9463c33d28f9ee9c7b0e7b0774289d36313500f7411f1"
    sha256 cellar: :any,                 x86_64_linux:  "05a2a80f5bc039a91e1c59dde6c4077990c8443c13db79ae4a3a3642be0073bd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end