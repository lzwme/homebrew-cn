class Meli < Formula
  desc "Terminal e-mail client and e-mail client library"
  homepage "https://meli-email.org/"
  url "https://git.meli-email.org/meli/meli/archive/v0.8.9.tar.gz"
  sha256 "4bd34e3aea53d07b99e897ff307c90537c5dcc9dc37b726107f09e7202cdb84f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0d8cc5d6f1a3d90a6de6089393946ca6ba3057c41ef3d31c0b07570925b5d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9fea34dc29ac676900202684b5277ee5109e797512c71db1807ece486c5d8a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e0c85dfad060a46e4ccb75af0425c14b0a2cab3cc8b67f6cafe8e461ffd924a"
    sha256 cellar: :any_skip_relocation, sonoma:        "486859abafe241ca1fc728e6fc741c600db170aa030836f8f511f00eac30441e"
    sha256 cellar: :any_skip_relocation, ventura:       "6f067dec046b0472bfa6f49eee0dad7e331148d07ca6befe9202416a2445ffe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95690ee8517b5a739dee1160124d5aa423576cbbaa151937af49b0ccbedeb6ad"
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