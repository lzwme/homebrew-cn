class Openlore < Formula
  desc "Persistent architectural memory and structural cognition for AI coding agents"
  homepage "https://github.com/clay-good/OpenLore"
  url "https://registry.npmjs.org/openlore/-/openlore-2.1.8.tgz"
  sha256 "e8c3fd1daabca7eda10419e2ec20d1c05357bdf70d483a954414cd2d2c691a65"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "1d8fa585cbcf3c04eff5df9eb0ff6bd4d9f453f17a1c353be34fca423dc279db"
    sha256               arm64_sequoia: "f4e9fb2d54cb94e5cad164a41595d1c13e6ddb42f205651c575ad5db5f3854e0"
    sha256               arm64_sonoma:  "516e8374479c6408c39efcf0aadc522d9d6c52e43f5f45e4e8d8d002a51d1d0f"
    sha256 cellar: :any, arm64_linux:   "9f7ebb51ad9b00e1d6482584ca47cc3bb4171ba1c7e420ad6909ca7069fcac5e"
    sha256 cellar: :any, x86_64_linux:  "f72a13b511f56e1cc75633121ad52c981ed386397a6916a6b9836544cf345f52"
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