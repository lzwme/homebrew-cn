class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.37.0.tar.gz"
  sha256 "35c64816a24ceb5aa9ec251d409c310137a8258fbc302c8c102d946e142738af"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89435c51811872cfb8306c60e2d19edbc9e698c47d014da1ab006de2c52400f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28923e8991436750601688c7025cce73a52f34ecdb3c558f13d26f465b72ab6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09711a3ff8f132ec817876eef145fd246b0de2c7a74a97703a79c33eecdcb4d0"
    sha256 cellar: :any,                 arm64_linux:       "be1c355be4acafae1d42dd5cadc6f01097f6c1d7f7b1cfd29183b0841e19507b"
    sha256 cellar: :any,                 x86_64_linux:      "54e4995764c4157734a7d0b46a1a89f5500319aa1d3ffc3ff031ece77e270328"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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