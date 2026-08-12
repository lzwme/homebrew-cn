class Openlore < Formula
  desc "Persistent architectural memory and structural cognition for AI coding agents"
  homepage "https://github.com/clay-good/OpenLore"
  url "https://registry.npmjs.org/openlore/-/openlore-2.1.9.tgz"
  sha256 "98f1af606fc8e28d0a8797466e7ba34ff41c713716275ebd905590efb84928b2"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "98ce38b5d06e2d29bb05e16abae80bf36e57f8e49e235d82443751ac1d8cd7b4"
    sha256               arm64_sequoia: "f6464cae51e35020b460d406153440bd02ef5ee25087528430a2eb38e8ffafaf"
    sha256               arm64_sonoma:  "a463d353837d3a0da6b04b56b7a1e349245a0ca1932b238335abc05059a86751"
    sha256 cellar: :any, arm64_linux:   "bdba21584d1a0b89df5395121aab4dacf693d35a06fce2c665c85555044be493"
    sha256 cellar: :any, x86_64_linux:  "4461e0b161c4143691e0630e8c6a1d40f7b77c246b071e69c4c1b12648442e3f"
  end

  depends_on "c-ares"
  depends_on "ca-certificates"
  depends_on "hdrhistogram_c"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "libffi"

  on_macos do
    depends_on arch: :arm64 # missing `onnxruntime` prebuilt binaries
  end

  on_linux do
    depends_on "python@3.14" => :build # for `node-gyp`
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/openlore/node_modules"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"

    # Prebuilds are unreliable (x86_64 mislabeled as linux-arm64); rebuild from source
    inreplace node_modules/"tree-sitter/binding.gyp", "c++17", "c++20" # node 26 headers require C++20
    rm_r node_modules.glob("**/prebuilds")
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    cd libexec/"lib/node_modules/openlore" do
      node_modules.glob("{*,*/node_modules/*}/binding.gyp")
                  .each { |gyp| system "npm", "rebuild", gyp.parent.basename.to_s }
    end

    # Keep only the native `onnxruntime-node` binaries
    node_modules.glob("onnxruntime-node/bin/*/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != os }
    node_modules.glob("onnxruntime-node/bin/*/*/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != arch }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openlore --version")
    assert_match "<!-- BEGIN OPENLORE", shell_output("#{bin}/openlore install --dry-run 2>&1")
    assert_match "Node.js version", shell_output("#{bin}/openlore doctor")

    node_modules = libexec/"lib/node_modules/openlore/node_modules"
    system formula_opt_bin("node")/"node", "-e",
           "require('#{node_modules}/tree-sitter'); require('#{node_modules}/onnxruntime-node')"

    (testpath/"test.ts").write("function foo() { bar(); } function bar() {}")
    assert_match "Initialization Complete", shell_output("yes | #{bin}/openlore init")
    assert_match "Ready for generation!", shell_output("#{bin}/openlore analyze")
    # call-graph nodes only appear when the native parser loaded
    assert_match "test.ts::foo", (testpath/".openlore/analysis/llm-context.json").read
  end
end