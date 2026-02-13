class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghfast.top/https://github.com/software-mansion/scarb/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "612c9a5167b8d089101a63923731f07d02cf07072c6438ce54388f7aeb3c86fe"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68dabecb501f79fa80e40354902c0fb86662c9bfcc35bb64576d566b5b13d253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25ec7cacb19d7c42f68436acbd58a39bf1987994ef0e56b4c932d78c3e777c96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f3df0b9dc1ef19a436db3272dc126aa84af5a6386d6aa7364b9e73b01df3bbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "a74de971be362170ad6d527bd48cedf113388e7e7abb90f6f1209f139feb46ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a87af999b32d029378ea56005bcd8e3ddce613121bab2c73b4b4a485efcf08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66e9da25510c689f19d576f1d9a98708e484ba67db0baae49774cd1649058efe"
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