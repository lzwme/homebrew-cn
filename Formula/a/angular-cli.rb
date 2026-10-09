class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.2.2.tgz"
  sha256 "4c55c21853a743fc8de231b3ca19e08b8fa640087ec3d57125e85b5f8e4029c7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "20dcc60da1b217bfa4388edf66357b57c3ad6a6f5e10176e91741af731714012"
    sha256 cellar: :any,                 arm64_tahoe:       "06b81b7db6530c2a5391b8f66d94149129e4b7b8eb63dbf92c0aab7b83dac06a"
    sha256 cellar: :any,                 arm64_sequoia:     "0e62f4e9c4ef01bf5d184ea780ab768e015200990beaaa2c80b8d38369cab4e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b4511f2d3a5f065691e31daf194f46fde935cef7698b60f32145043470c0d6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b64bf60369345829169a4de72f98a7be4bf009e1cb7457b3a616c17f69409e32"
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