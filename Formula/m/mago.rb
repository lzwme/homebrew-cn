class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.0.18.tar.gz"
  sha256 "98f1dbcd9d280e8d2a59a9805309c5856c475f82f55f22f44cdaae1830f4274d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9fb281a9e69d669dbfd6ea50cc25f6c3368e59d570fb8933c9b7b93c547887e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6809e390185816764b15c14ce5f866a801edc5d845454f5a40b88bd523a064c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "465443107caa45bb6400e0e491ef1bc3cc79a27511e2b88a8a06488381e3d354"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fef25b166d88397583f91bcd308dcc87a119c18af6c7a29829007ae926302e4"
    sha256 cellar: :any_skip_relocation, ventura:       "9120647f1fe8fbfab16bb9cd2ab108a9bf0b0da9bc4952b7ee07d683cc401de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2739abdda55809f42ed18d8034a81435d2fd9d0acfff76294b1c3af0ec85d9b9"
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
    assert_match version.to_s, shell_output("#{bin}mago --version")

    (testpath"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}mago lint 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin"mago", "fmt"
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath"unformatted.php").read
  end
end