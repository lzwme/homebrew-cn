class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.20.1/source-code.tar.gz"
  sha256 "97fffcc4c967820f8094e9a39873e5987f579118a44049e7a0057134fb6db374"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4547529d81a010dff75de06bd5b92c9c93be8e40498871bac511d344a5ae672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be46fb7b0b261b738b22048fe65bffec0d2d95ac85bd17680c676df0d8c5ec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e768fc8b0748c32c81f7a2b240dc3e2190c863f0c5e42875323e827c3deaac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d957b886c94d4c5dc78a79b75a8efbfab7e0b727e47d8e288026c475cc5044e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "febef9c2dff3fb0b10c5e0efd06609dd9884f76091e0e043f42d9927cdc9da7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb68d4ee56fb7e57df104035738a8334752bbe937e0256e9d42025879fee61d7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end