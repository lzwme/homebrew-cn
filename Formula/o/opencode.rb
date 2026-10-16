class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://ghfast.top/https://github.com/anomalyco/opencode/archive/refs/tags/v2.0.29.tar.gz"
  sha256 "3d88f662bce9bee4b0af1cf7528f752039dceb4062811c5eae046649ce1dec2d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "e712f1e880ae47d2cf5dd652a21d04f332d64bd3cb759ac4c306001a2acea411"
    sha256 arm64_tahoe:       "3e05ad899e655f1953305e04ea2a6e5568b8802bcee744df2dfd0a912736a616"
    sha256 arm64_sequoia:     "b1c3f10aede5ed42dc5226343473eb4759211348f07f0786c9537867e550a7df"
    sha256 arm64_linux:       "6f0b66095b7ff2b14b1d2f7bc295cf9b3d9be16d542533e7ebf8726fec8f917b"
    sha256 x86_64_linux:      "8ce66e855ce930a6819923dd384882ab638c729dce13a5177f34df6924e664c1"
  end

  depends_on "bun" => :build
  depends_on "python@3.15" => :build
  depends_on "rust" => :build
  depends_on "zig@0.16" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@78"
  end

  resource "opencode-pty" do
    url "https://ghfast.top/https://github.com/anomalyco/opencode-pty/archive/refs/tags/v0.2.0.tar.gz"
    sha256 "7fc1d1ebf4b74cd1b2a83f059afa29a899990b85cf078e73b703004370a52754"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/anomalyco/opencode/refs/tags/v#{LATEST_VERSION}/packages/cli/package.json"
      strategy :json do |json|
        json.dig("dependencies", "@opencode-ai/pty")
      end
    end
  end

  # opencode-pty's build.rs requires a git checkout of the revision in its `ghostty-revision` file
  resource "ghostty" do
    url "https://github.com/ghostty-org/ghostty.git",
        revision: "ab0b9da9e88fcb4b0533a1854e84628f663930af"
    version "ab0b9da9e88fcb4b0533a1854e84628f663930af"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/anomalyco/opencode/refs/tags/v#{LATEST_VERSION}/packages/cli/package.json"
      regex(/^(\h{40})$/i)
      strategy :json do |json, regex|
        pty_version = json.dig("dependencies", "@opencode-ai/pty")
        next if pty_version.blank?

        revision_url = "https://ghfast.top/https://raw.githubusercontent.com/anomalyco/opencode-pty/refs/tags/v#{pty_version}/ghostty-revision"
        ghostty_revision = Homebrew::Livecheck::Strategy.page_content(revision_url)[:content]
        next if ghostty_revision.blank?

        ghostty_revision[regex, 1]
      end
    end
  end

  def install
    # Build the persistent PTY helper from source instead of embedding the prebuilt npm binary
    (buildpath/"ghostty").install resource("ghostty")
    ENV["GHOSTTY_SOURCE_DIR"] = buildpath/"ghostty"
    resource("opencode-pty").stage do
      system "cargo", "install", *std_cargo_args(root: buildpath/"opencode-pty")
    end
    ENV["OPENCODE_PTY_BIN"] = buildpath/"opencode-pty/bin/opencode-pty"

    ENV["OPENCODE_VERSION"] = version.to_s
    ENV["OPENCODE_CHANNEL"] = "latest"

    # Fix server errors when building with Bun 1.4.2 by disabling splitting
    # https://github.com/anomalyco/opencode/issues/48645
    # https://github.com/NixOS/nixpkgs/issues/563241
    inreplace "packages/cli/script/build.ts", "splitting: true,", "splitting: false,"

    system "bun", "install", "--frozen-lockfile"

    cd "packages/cli" do
      system "bun", "--bun", "./script/build.ts", "--single", "--skip-install"
      bin.install Pathname.pwd.glob("dist/cli-*/bin/opencode").first
    end

    generate_completions_from_executable(bin/"opencode", "--completions")
  end

  test do
    ENV["OPENCODE_DISABLE_AUTOUPDATE"] = "1"
    ENV["OPENCODE_DISABLE_MODELS_FETCH"] = "1"

    assert_match version.to_s, shell_output("#{bin}/opencode --version")

    (testpath/"opencode.json").write <<~JSON
      { "agent": { "brewtest": { "description": "Homebrew test agent", "prompt": "hi" } } }
    JSON
    # The standalone server listens on localhost, so network access can't be denied here
    entries = JSON.parse(shell_output("#{bin}/opencode api --standalone config.get"))
    project = entries.find { |entry| entry["path"] == (testpath/"opencode.json").realpath.to_s }
    assert_equal "hi", project.dig("info", "agents", "brewtest", "system")
  end
end