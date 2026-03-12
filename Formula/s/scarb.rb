class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghfast.top/https://github.com/software-mansion/scarb/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "fb02bb880a22494a63b61e7e0669fcce1e61250db0b0bd60942114a1c0dcb640"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f02f4e1a456055cce04e7c7bf65a6f20ee36b6ed008784ecc75bcdc78c3c8e69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4db1b321aec4bfc0604bd71aa1965859bc994c417c0429200b6ac6b571dc689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca127274eaf1c336de409554053fc830f6167c0c02000332058ae933c5253e0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4614bfdc5d79c60b17585bfbb65a587adbc61f655458ba4be5491764c890e74f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08ca8caf80bd686903b152b046bd0505edd5fdccf60bdfce080320b0bd8263d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c101ae146bcaff382ebd0372ea72385b50bb281389491f44257c8eac31086d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "none"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end