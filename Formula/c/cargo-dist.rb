class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://ghfast.top/https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "b4c020a737f1a01615ea76baf4814f00667015d4b1e6931ccc9b35bfdf4d2b84"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0420176b9ebeba62bf5b6e3c42a7dc0fa0a1f0e376f856ebcae19c6ef5c5e7b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5f90e1a444550d52dacedba0ebf95a4220fb7c89ba8723fa647a95322fdba80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b8b0211e6e849e933a3b1227c0613182ec096c1ae05b1bf87f364c6d0ddd68d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ed22d0072c7d23ae1c9bd4cb96fdac4d62e2bc0fc62f2356a1cff5bd806ae71"
    sha256 cellar: :any_skip_relocation, ventura:       "4b71bbda7a353d318d3b5d5c9d0adfa6eff374b1656db12159d8d3e84c725415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82b3edfbefd05553849af17f609fdc26d12ce11f6b30ea7f60309a0f1678d06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3071558c48fe55823d02267a26f97a8726c9e16a7862e85188f61228f17fa31"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  conflicts_with "nmh", because: "both install `dist` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-dist")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/dist --version")

    system "cargo", "new", "--bin", "test_project"
    cd "test_project" do
      output = shell_output("#{bin}/dist init 2>&1", 255)
      assert_match "added [profile.dist] to your workspace Cargo.toml", output

      output = shell_output("#{bin}/dist plan 2>&1", 255)
      assert_match "You specified --artifacts, disabling host mode, but specified no targets to build", output
    end
  end
end