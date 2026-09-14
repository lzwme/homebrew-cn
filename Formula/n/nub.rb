class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://nubjs.com"
  url "https://ghfast.top/https://github.com/nubjs/nub/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "76cdad3d6a047aba688330b95b926aecc6b725fe5c966014144c37505881307d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47b620433f76e9f4c537809f6a0cadc0f528b21cc718cc365fedf9f2ea32dfd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59a2a34dd7f880220cff2401c322066639b4ae84452693e4c9cd996256a4c249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e99424cdb99837696c549bd43f72e44be31dbd7aea17b6751097f2536b63c3b"
    sha256 cellar: :any,                 arm64_linux:       "e59bd11b971ee4b0761b08e229a2445087942284469b228fdd691893b9c270b8"
    sha256 cellar: :any,                 x86_64_linux:      "c3b799e6ac399012513ac2864325e576b94e7c3f18309cd62143b65e7f3e52be"
  end

  depends_on "cmake" => :build
  depends_on "node" => [:build, :test]
  depends_on "rust" => :build

  def install
    # `runtime` has no package.json, so npm resolves up to the repository root
    # either way. Install there, where package-lock.json pins the versions.
    system "npm", "install", *std_npm_args(prefix: false)

    # The `embed-runtime` feature tars `runtime` into the binary, and the tree that
    # binary extracts at runtime has no parent node_modules to resolve through. Copy
    # in the packages that tree loads: the transpile helpers and the web API
    # polyfills. Without them the build still succeeds, but the binary fails to run
    # any file that needs a helper and silently drops Temporal, URLPattern and
    # Float16Array on Node versions that lack them natively.
    %w[
      @js-temporal/polyfill
      @oxc-project/runtime
      @petamoriken/float16
      jsbi
      urlpattern-polyfill
    ].each do |dep|
      (buildpath/"runtime/node_modules"/dep).dirname.mkpath
      cp_r buildpath/"node_modules"/dep, buildpath/"runtime/node_modules"/dep
    end

    cd "crates/nub-native" do
      system "cargo", "build", "--release", "--lib"
    end
    mkdir_p "runtime/addons"
    cp shared_library("target/release/libnub_native"), "runtime/addons/nub-native.node"

    system "cargo", "install", *std_cargo_args(path: "crates/nub-cli", features: ["embed-runtime"])
    bin.install_symlink bin/"nub" => "nubx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nub --version")
    assert_match "Usage: nub nubx", shell_output("#{bin}/nubx --help")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-app",
        "version": "1.0.0"
      }
    JSON

    # Transpile a file that pulls a helper out of the vendored runtime node_modules.
    # Legacy decorators are down-levelled on every Node version, so this covers the
    # embedded runtime whichever Node is on PATH.
    (testpath/"tsconfig.json").write <<~JSON
      {"compilerOptions": {"experimentalDecorators": true, "emitDecoratorMetadata": true}}
    JSON
    (testpath/"decorated.ts").write <<~TYPESCRIPT
      function log(target: any, key: string, descriptor: PropertyDescriptor) { return descriptor; }
      class Greeter { @log greet(): string { return "hello nub"; } }
      console.log(new Greeter().greet());
    TYPESCRIPT
    assert_equal "hello nub", shell_output("#{bin}/nub decorated.ts").strip

    system bin/"nub", "config", "set", "registry", "https://registry.npmjs.org"
    assert_match "https://registry.npmjs.org", shell_output("#{bin}/nub config get registry")
  end
end