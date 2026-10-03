class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.2.1.tgz"
  sha256 "797ab1bf9caca4c8a1c2bc3750b984f27ec24142c31fb491fdb9ccaf2c3522eb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "7c1b47fcc22cd0b9e2d95ce04c0eea30cdf25519fb0d5cf90da6e4c2ca607d38"
    sha256 cellar: :any,                 arm64_tahoe:       "d98313e3eac6bf11d5c63d1a301db89c4960ab7c54409121c1293523e01aa59a"
    sha256 cellar: :any,                 arm64_sequoia:     "c704a7c62695e1623468f6d4aa9db094a150c6e85eb9c38b17aab8a9db997729"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f22360c7596c1e119af2286187386453dca9ea38ed04c58e90841c4a6ff9f263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "62993cc6a7ae58d6995df8dce31eb0d9b8688dac903efcd4dbdf63aeeef90009"
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