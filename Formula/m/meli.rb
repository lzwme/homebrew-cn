class Meli < Formula
  desc "Terminal e-mail client and e-mail client library"
  homepage "https://meli-email.org/"
  url "https://git.meli-email.org/meli/meli/archive/v0.8.10.tar.gz"
  sha256 "09d1a46434a86f5f2d212ade224712f14aa36a6b12a5df7a2660830c8097e775"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://git.meli-email.org/meli/meli.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1571c7e82e165e2ec607174e330003e26b41b7c79c38202bedb5250f795ceb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfbc0df0186579d1293c1deb7937f4496eae9b4857607cec14b06538d01b8231"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a8e8667a3b302d0218aee80ef6c1ccdc019b10d09ca883f093071f036e2d329"
    sha256 cellar: :any_skip_relocation, sonoma:        "5474fed898112584fa8702ab921dc7ad2cfad77a89d80b4cfafc36d6dd58620c"
    sha256 cellar: :any_skip_relocation, ventura:       "aec465c9719c02383f829231d16dc75ad61df212f77a68c5a654e837b3fa3052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b342df05d539c17ce08acae9579e29b14f6cbf3c578971aa0ad482b03be797"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "meli")

    man1.install "meli/docs/meli.1"
    man5.install Dir["meli/docs/*.5"]
    man7.install "meli/docs/meli.7"
  end

  test do
    output = shell_output("#{bin}/meli print-config-path")
    assert_match (testpath/".config/meli/config.toml").to_s, output

    assert_match version.to_s, shell_output("#{bin}/meli --version")
  end
end