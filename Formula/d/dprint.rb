class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https:dprint.dev"
  url "https:github.comdprintdprintarchiverefstags0.44.0.tar.gz"
  sha256 "2b398f4c22d2852d21cbc2afef68d7f8fe0775f4bf3959188ac13455e3969e2c"
  license "MIT"
  head "https:github.comdprintdprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29c6b6e6bde5e501d141fded7da74a5baf37e59940162bb835ca931bb59628fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "246b9fa683ab5abcfb035e655f4927a812e8bfc5677fb21264fbe1b8bcd0b173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5340e66289d2532cdc5526001f0b1a99bf870a6bfecfcd1eaf8e7b6d4bef606d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d2b0d40d4c613560a0706280e80bf2fbfd58687574a500a7f3b7966436c2927"
    sha256 cellar: :any_skip_relocation, ventura:        "68c2d1a90380b7d59db74e4816370f4d7f5f9b619795c4c2226bb994bd644f67"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc6dd2884ea41b790990343b9e67b59bd0d2d12ac6cd9175f0cbb805296ec15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e28bd7e483f6377141a1da7fc33e8f9532330853a115375a1a4a5307889816"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesdprint")
  end

  test do
    (testpath"dprint.json").write <<~EOS
      {
        "$schema": "https:dprint.devschemasv0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["***.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**node_modules",
          "***-lock.json",
          "**target"
        ],
        "plugins": [
          "https:plugins.dprint.devtypescript-0.44.1.wasm",
          "https:plugins.dprint.devjson-0.7.2.wasm",
          "https:plugins.dprint.devmarkdown-0.4.3.wasm",
          "https:plugins.dprint.devrustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath"test.js").write("const arr = [1,2];")
    system bin"dprint", "fmt", testpath"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}dprint --version")
  end
end