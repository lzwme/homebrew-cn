class Noodle < Formula
  desc "Terminal REST client with file-based collections"
  homepage "https://noodlerest.dev"
  url "https://ghfast.top/https://github.com/wilfredinni/noodle/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "71778afecc1efdac23a822b7330c9703d85d47b9d95f20b4f2856ad3df6a34ef"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "1171c75eb2d87c31940a6c27365a653a03e85bab97da77e32a5fdc3bede9ecff"
    sha256 arm64_tahoe:       "bb746bdbfa14b0481969a3029776cd0c47510046ca9e29e6a2db7a16e881773c"
    sha256 arm64_sequoia:     "fc5eb60b13ac4cc1a21f0bbde8ae360f18c225ea1875441c2e74ca785cfc4bca"
    sha256 arm64_linux:       "5e8ed1abe2582c75df03644a499a9ed389bf90ad87dfe7eda433b291339bc9ed"
    sha256 x86_64_linux:      "4b6ec0afe44e7462baf77427afdeac667d404486c6180f3c14f96be4e72eadec"
  end

  depends_on "bun" => :build
  # TODO: Use zig when Noodle's OpenTUI build supports Zig 0.17.
  # https://github.com/anomalyco/opentui/pull/1586
  depends_on "zig@0.16" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  resource "opentui" do
    url "https://ghfast.top/https://github.com/anomalyco/opentui/archive/refs/tags/v0.5.14.tar.gz"
    sha256 "0e092b7405934c3a30f6eca2cb6e35eb00d9d8948d15daa69af2371e1e641a6e"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/wilfredinni/noodle/refs/tags/v#{LATEST_VERSION}/package.json"
      strategy :json do |json|
        json.dig("dependencies", "@opentui/core")
      end
    end
  end

  deny_network_access!

  def fetch
    ENV["BUN_INSTALL_CACHE_DIR"] = buildpath/"bun-cache"
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    ENV["BUN_INSTALL_CACHE_DIR"] = buildpath/"bun-cache"
    resource("opentui").stage(buildpath/"opentui")
    system "bun", "run", "build:homebrew",
           "--offline",
           "--opentui-source", buildpath/"opentui",
           "--zig", formula_opt_bin("zig@0.16")/"zig",
           "--cc", ENV.cc
    bin.install "noodle"
    pkgshare.install "LICENSE"
    pkgshare.install "opentui/LICENSE" => "LICENSE.opentui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noodle --version")
    system bin/"noodle", "collection", "create", "brew-test", "--output", testpath, "--json"
    collection = testpath/"brew-test"
    (collection/"probe.yml").write <<~YAML
      name: Probe
      method: GET
      url: http://127.0.0.1:1
      scripts:
        pre: |-
          await Promise.resolve();
          if (noodle.crypto.randomBytes(4, "hex").length !== 8)
            throw new Error("homebrew-crypto-failed");
          throw new Error("homebrew-quickjs-ok");
    YAML
    inspected = JSON.parse(shell_output("#{bin}/noodle collection inspect #{collection} --json"))
    assert_equal 2, inspected.fetch("data").fetch("requestCount")
    output = shell_output("#{bin}/noodle request run probe --collection #{collection} --noproxy --json", 1)
    result = JSON.parse(output).fetch("data").fetch("result")
    assert_equal ["script"], result.fetch("failureCategories")
    assert_equal "homebrew-quickjs-ok", result.fetch("scripts").fetch("results").first.fetch("error").fetch("message")
  end
end