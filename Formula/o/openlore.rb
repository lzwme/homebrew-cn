class Openlore < Formula
  desc "Persistent architectural memory and structural cognition for AI coding agents"
  homepage "https://github.com/clay-good/OpenLore"
  url "https://registry.npmjs.org/openlore/-/openlore-3.3.0.tgz"
  sha256 "db8c822820a169e0c621e8157674872056e63cfb39d5a927c0e973f9abe954e0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e0eebe7431bf694a2e4cf4e597b09c497e7a0e0ba8a26b71bb0257697f8a6afb"
    sha256 cellar: :any, arm64_tahoe:       "966a45326237d07d510d43ea567e0c42ce1165bbc9a9a67d138f37869cb72782"
    sha256 cellar: :any, arm64_sequoia:     "5b4bc76e22dc50c1ae7a2f1aff5d8be648a8cbc6410511668aa58520b194ce7e"
    sha256 cellar: :any, arm64_linux:       "7bc11c40098dc43b8b3ed09f9aee3437d42ef8c7029d0b31083ab039ab207a2f"
    sha256 cellar: :any, x86_64_linux:      "da877061968006e2d387cd588e798d317410e0c69c31343d41448245bd486545"
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

    # Keep only the native `onnxruntime-node` binaries, which `@lancedb/lancedb` also nests
    node_modules.glob("**/onnxruntime-node/bin/*/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != os }
    node_modules.glob("**/onnxruntime-node/bin/*/*/*")
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