class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.2.4.tgz"
  sha256 "e700c9c03f8ba4ac6dd47b3a29cb7466ccdd30c346902e2f393b4b16020eea66"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a519ec3648c5e29717dbf6a19b9e31d2f5d9ae8f08f7bc0a1fceb3dd2d675ac3"
    sha256 cellar: :any,                 arm64_tahoe:       "cc70a7f44abd213a194fa0a7b1d32d209ba0543dbdc1f291d087ac3bc30f59d6"
    sha256 cellar: :any,                 arm64_sequoia:     "37551aa446b32de16eaa4e6df30794b9bf67b3b9320e230b988df7d316e6a60b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de7f0e57be66913fcadf6847c8fc29d8756895eec04e6583261dc0e589ddeea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "182ef5b9404edbea1fa3a61a846cda81bff535ab77e0b9e9d9491d3a0a7f6bd0"
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