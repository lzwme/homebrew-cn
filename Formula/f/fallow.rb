class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.100.0.tar.gz"
  sha256 "32588da99e86784eac4050e278407786992d4553c71427511a54b3c0ffe75212"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b719fd7dc5ab3ca151345fe4784164e85a09ebc248c77949488bf1f59a265764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2acb213b70a80eecc27a5d56863e2e83f18eda7f7ea5151c7023ec098dcf153c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8658d3f7a3d19bc5992bdf078ef9e04df92ad796364af46cf0bd308af29f4d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "25f19d12fed193c6d7069bfc834c4bef121e43d53e65b44e42e9f7c931ffcff2"
    sha256 cellar: :any,                 arm64_linux:   "ac7ab05d7c1a45611c3302644a17bf5a159bf990044265d847184fe373e806d3"
    sha256 cellar: :any,                 x86_64_linux:  "709dd2e5bdf8b32eba7cc70b44018d97cb8a0df0d24907b20d551494b5a75ba5"
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