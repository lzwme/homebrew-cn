class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://ghfast.top/https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "669ca3be2543597c8f4630e957e86b94f3df4f62c20de6ab9ffb3dd3931f762c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2364004a5bfecd5c922686cd24e32db725f45e7c6ae3700a943c4d56832cccd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f72057ab877e22ef1eeada83edee771a2f83ec251475dbe2d8105ad05c4ed92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eef20dcbb233dfbeca1425bb736f22f9da63136d71a02d0863f03b09426ee9d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b8b634ba9e4aadf3c4fd9471e8ed88b5901e087909ef4324c68b797f7ba99ec"
    sha256 cellar: :any_skip_relocation, ventura:       "74aa896285357666e6b08f027e574fa207272a95c5f3ac744e9e40b4237b5565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7781a982543c1b4be01828aa700ae0db2bcbc3365caafa0f007708a8c2788883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e4ace972035bd39cb80e1e30fef43373871982011abdfa4032ac3bc67b9f973"
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