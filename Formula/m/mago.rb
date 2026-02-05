class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.5.0.crate"
  sha256 "fdb1056f4da31e3418dcf2e134f721a66b8131913a4124549b69e8da719921c4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e18a9432faefdd8a03b162d345cb166316c39cf2befe634fd4b5027cbf50430c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dfc14f61b20e43a564248bddfc3be796f7740954a7125e541dc97438281ac87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5acf517c21611e2454c1990c708d376738253703e78cd97a2620d5ddc2508f2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "387378cc7fcb9fd71b2a078820e1bf3795b3481773b946a5a7df6b9dc1ff86c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d61ecada04163692241f623908d7c7a4cc38895716ccb43bb3f8ba29136ab66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2026a628b12538009b5f1d8d8f766d753605a7549fe7a57b5554bcc07bc76d70"
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
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end