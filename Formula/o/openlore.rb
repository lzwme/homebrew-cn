class Openlore < Formula
  desc "Persistent architectural memory and structural cognition for AI coding agents"
  homepage "https://github.com/clay-good/OpenLore"
  url "https://registry.npmjs.org/openlore/-/openlore-3.3.1.tgz"
  sha256 "6f810ed71db54a9989b27176fdca0a923676bf2f71a86fe6eb9feb2e119eda90"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e6d85baf98392de5a12370309524d494b5fb16440896ef6ddd9317f2e372d5a8"
    sha256 cellar: :any, arm64_tahoe:       "769651731e5f69b446a071f6f3bf5cc818c8269b77b6ce0c8e83e4fb8389dac3"
    sha256 cellar: :any, arm64_sequoia:     "0fb246b11b51f3950434fce3a1b4ceebc52e91a585efd6682f10de2f16fa2bb6"
    sha256 cellar: :any, arm64_linux:       "5ee7006e26919c1e551f9865a729951f6cf65f8a80bc768a6e1e0951f9188451"
    sha256 cellar: :any, x86_64_linux:      "4881c9ddca576765a6e2e2ea8462ababecbff7ed36f0e290c807b5390aa80fb8"
  end

  depends_on "node"

  on_macos do
    depends_on arch: :arm64 # missing `onnxruntime` prebuilt binaries
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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