class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.2.0.tgz"
  sha256 "04dd0655fecc1a3ae4407a455b469d5d6b6afe9dcdd5f306d4a5580c9af362ca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "45e8a15c407bd3216675097c4e2ea4e9d4b27e8682949edddc55d024bdb166ce"
    sha256 cellar: :any,                 arm64_tahoe:       "69ebb1152452e048eaa169f5fd8cc065e29d879c5546f39748f31c7ef46f9a16"
    sha256 cellar: :any,                 arm64_sequoia:     "c9b202be74a59d14390246ba044750e31648a2913e85a6fdaf48aa0c25a2b25c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "feaac64b2353d48c3b6eca45c9d85de314e53d5abd13c0ffb6c46c0fe15f5397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a8cf5f96362dd5e23c3443a72e2ed080765f103d57a58e47a4ba047d2e754715"
  end

  depends_on "node"

  on_macos do
    depends_on "rust" => :build

    # Rebuild the prebuilt `oxc-parser` binding as it lacks header space for relocation
    resource "oxc" do
      url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/crates_v0.150.0.tar.gz"
      sha256 "08a7d805dc76f773cc5aeafa4adebe276f841cc30671e19fa05f10258293e567"

      livecheck do
        url "https://registry.npmjs.org/@schematics/angular/latest"
        strategy :json do |json|
          json.dig("dependencies", "oxc-parser")
        end
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@angular/cli/node_modules"
    oxc_parser_version = JSON.parse((node_modules/"oxc-parser/package.json").read)["version"]
    odie "Update `oxc` resource to #{oxc_parser_version}!" if resource("oxc").version.to_s != oxc_parser_version

    resource("oxc").stage do
      system "cargo", "build", "--lib", "--locked", "--release", "--package", "oxc_parser_napi"
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      cp "target/release/liboxc_parser_napi.dylib",
         node_modules/"@oxc-parser/binding-darwin-#{arch}/parser.darwin-#{arch}.node"
    end
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end