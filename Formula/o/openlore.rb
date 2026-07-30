class Openlore < Formula
  desc "Persistent architectural memory and structural cognition for AI coding agents"
  homepage "https://github.com/clay-good/OpenLore"
  url "https://registry.npmjs.org/openlore/-/openlore-2.1.7.tgz"
  sha256 "86e36f8cfd66f3594d2825d31a5954b565312dd5e1210840a74ca6109f8f0c8c"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "83e152c669038230d0d49106361e85b587edb494b95f9c2d02fa555697364dd1"
    sha256               arm64_sequoia: "3974fa853a57f1ec310c8d118aad98a48e9298518ce821fb350880cc15f0de95"
    sha256               arm64_sonoma:  "f21059aaba7bb09e0675a65a496318a286b6ef4733955864cae7e48694ccd6aa"
    sha256               sonoma:        "f9e65965f50bbfefe3dcd358ae736a56375ae39999a44d6f1c907b162873e8b1"
    sha256 cellar: :any, arm64_linux:   "a9fb99225f8bd96c4fd1ee36e62ed7b6c5e4206609469f98e5a7b435bdd81a57"
    sha256 cellar: :any, x86_64_linux:  "e33333087d016b471632fbdcfd643a611987ecc5774f589b9cbeb6f17960da66"
  end

  depends_on "c-ares"
  depends_on "ca-certificates"
  depends_on "hdrhistogram_c"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "libffi"

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