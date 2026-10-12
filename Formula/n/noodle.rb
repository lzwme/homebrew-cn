class Noodle < Formula
  desc "Terminal REST client with file-based collections"
  homepage "https://noodlerest.dev"
  url "https://ghfast.top/https://github.com/wilfredinni/noodle/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "b1678e5807c4368b3c502002b6f75f61dc7a16eb9c370db10493c8e171674347"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "8385a3b6dc42edec08c42ba7b0ed1d14164ee5ec420127d25cd236b5c78e174f"
    sha256 arm64_tahoe:       "1ddf5340e09c5e720e032e558836ac6a5adea9697ab1efb4c8b4d3799ade017f"
    sha256 arm64_sequoia:     "d757b04783b64e518f49cc70ae9c41052f04382b503ed2981bbab9030f9bfffb"
    sha256 arm64_linux:       "e2c438752dcbb0caa4a971847b051deba627c573736bc515d4212edd5a8e89aa"
    sha256 x86_64_linux:      "668006f56dd3bd53b7b5fdea1a51ff6136e73b56cdfcc8b3a862bc76c03fd4d2"
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