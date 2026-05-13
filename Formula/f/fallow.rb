class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.73.0.tar.gz"
  sha256 "27c8a27d9a222d1f5a0e2ca52aeb06a0f75c850bc59fd8e7878abb3bea5d6a56"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61caa4584c1b4931797753e603cd91cd1564c070879a7c3b876cc903275e60e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9faac284fb78f25a5c388efadce1a2ace5bc4f54d16186180040df23121483b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ff10b8fe22917b6f04f926f81ef3633a1110fb777bca09bc9ad6bf59ba83a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce1d4f5a82fb453df75f0c0aa4cae28947607b3d46af195abb4f531f71ed8fe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b50af2be97038f00e819553ee739f8486c2d4c05606b97b02e7a61e921a28d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c980ef8533d900a5bab06ae3909a16a975e042d5114f8d862acda01e91c164b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")
  end
end