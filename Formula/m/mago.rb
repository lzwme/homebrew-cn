class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.0.9.tar.gz"
  sha256 "85d704a4017204a97dcc1adffa5c7bd9f50e3b5d8e0219da37a6428846e44ef1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce8e771d2c12b9489a58dedc6f13bd001877e49dd72c59d52b9840767258ac7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c32f01e3e6d0a3e43a1001754032264bab5682741d30f7caf0c592bdc614016e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83e4ccc074614c86e4a08816cd21a868411e4b1a1523891403e3ff094365b50b"
    sha256 cellar: :any_skip_relocation, sonoma:        "976dac8972a7e7dae61f5b6caa6143c029bea0bd0d308c9cf356463a2a53e729"
    sha256 cellar: :any_skip_relocation, ventura:       "763ad66105d457e3dc2618174d372c9b9db3ede4bb7e6b9abbf402fccbdf96bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8758c6bf8e893ab584c0e04698e8e9ce8b12e61d7f433b895043d39d77556f46"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mago --version")

    (testpath"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}mago lint 2>&1")
    assert_match " missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin"mago", "fmt"
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath"unformatted.php").read
  end
end