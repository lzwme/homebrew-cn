class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.0.2.crate"
  sha256 "a2ee924d3152d900ab3c21a5a27e79ae3b6b61bb9fc2b190091a2d066d80023d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0af7ff252a8a008e92bb56b24f8abb99046ff206f1940a1933b5c7332ad69ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecc3d6395b515233402073a23921c901408269fbc5b513507151b9e143664081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e94cac65c00c4bf67e3425f2b94f9bb6c23efb6ec6f850a3fcb4eb853c12f192"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4477b9f76e348e5d7e2ef519505e9d0aa719e8733eecf14052b3795582abdc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30f65bf742027599c78407439211c1e72d3c45855423b8b6f6451fbfef702854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f84e1afa4b675e5b07d7cf609f050390a36ff42cd021ab7e5e6dd646ac96b40"
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