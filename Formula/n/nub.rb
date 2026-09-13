class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://nubjs.com"
  url "https://ghfast.top/https://github.com/nubjs/nub/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "e42827f0ad1b416670c30c584ed5a065fd1ffa620e35a8b8b60fa817c58d5511"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f9ccd6ec921df300b7733abdc4950d44e9c9b701f3711a6624099d2689db161"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18f7ee2db9d5e206065ee6c1c2bfcc5f98ccb479ee8a47e0f0c1078e29da2187"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d3a73501550721b1ff674dd82fd0b8782fafbb2cec2a84f0daa49a32d0e08681"
    sha256 cellar: :any,                 arm64_linux:       "4eb8a131164ac2e605482031b278904afdb115f348e028f2774ca54cf1ccb608"
    sha256 cellar: :any,                 x86_64_linux:      "f63cf5226fa450686d234902340a868456e57edeb420f678c628a06f060365fa"
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