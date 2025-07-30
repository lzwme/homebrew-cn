class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.9.0.tar.gz"
  sha256 "0e5ac079997712367753c710caf45d93387ed8d53f8893adb630d09ea7c7675f"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b5b7db58974d1998126b7988fa3c179ade0d4accb2072d7dc1702f4616fb1d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9d6dbe08863ccd71a2117f8660d468b12ca76f6bbecc689e2827ced0c8fe984"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66ae091848f5868f34c9b7424e8868fbf2f3611e85145e34323072cef8b848f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d2e1bcc525628b9529c8d06a0fcb7afbe5d5a1a0af3db1fa7943c9f1cfa8d2b"
    sha256 cellar: :any_skip_relocation, ventura:       "9c8d9931e2eafb246dd08585d431ded4404c08be988c58097fb99807ffc4b8ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d4edb15e1b564dad08000c5a347009f62761c437fe1e507b6ef3d40da73d51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fbbd7d4de713d16df82875efa6e09f13274955ae84b17d89e8b24988efbf850"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end