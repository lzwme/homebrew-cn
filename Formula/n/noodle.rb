class Noodle < Formula
  desc "Terminal REST client with file-based collections"
  homepage "https://noodlerest.dev"
  url "https://ghfast.top/https://github.com/wilfredinni/noodle/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "16f869ec37275e39234e47b7f0c9f27e76530f570b0fa4da031a75a83cd7530b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "b888425575aa68b81458e9b25b03d0bb10fd69ccadb074fe3fc9854aeac85cd6"
    sha256 arm64_tahoe:       "14e201f06a3db0d443e3fe63c5146e3c72e5301455806840e5250b1fa842e319"
    sha256 arm64_sequoia:     "e98a430d3e4578450192deee3a41d1d87855ffdb8316c61c6120ec4cd80a7343"
    sha256 arm64_linux:       "4045a71055d54f78a4d588967a8d9c2ddd89295de34de68f5d747a6610cc713b"
    sha256 x86_64_linux:      "49720f76ab80379e23b7bd348e31ed72a3aa0b6d33210075f37145e16c46ba77"
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