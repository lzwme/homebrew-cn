class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://ghfast.top/https://github.com/anomalyco/opencode/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "eb16e1b9c504fff1e7d8679d7a88421967a403a7bb223e8993879a46735ff61f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "fe028bd6ed6f2b4865c8d1974bf77a8fe3dc77a0213ce950b9d8a6cda0605af0"
    sha256 arm64_tahoe:       "52fd8af89e77e55da18b10dabb9e3cc6be26a1d96db0cd55e227ee734e0cedba"
    sha256 arm64_sequoia:     "61b63601216b068eb8dd66a38132fe5cba6d8bc3d6806e5bfe9b394f18bdffbb"
    sha256 arm64_linux:       "7870ed2af167898340e23c81d9535f8226266d1f6b99d3d47d0e533373d0fd3e"
    sha256 x86_64_linux:      "c18fcf6d73c112798b0f792aae2c3a29b821963d89b56bc98fd4555b9f13a19a"
  end

  depends_on "bun" => :build
  depends_on "python@3.15" => :build
  depends_on "rust" => :build
  depends_on "zig@0.16" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@79"
  end

  resource "opencode-pty" do
    url "https://ghfast.top/https://github.com/anomalyco/opencode-pty/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "101efcfde719cd9ead649d1fc1e1c31a31e89c854bf63b9cd2e977a7661f18a0"

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

  # Ghostty's `translate_c` dependency pins this archive in its build.zig.zon.
  # Zig fails to fetch it on macOS CI with `HttpHeadersOversize`.
  resource "aro" do
    url "https://ghfast.top/https://github.com/vancluever/arocc/archive/ecbc5c799574e0da2758a961b12efa586007f03c.tar.gz"
    sha256 "aa54487bd727e8fa36744ff0a824dedb2f4ca45f4c2d4d9d2437cf5fd3d0ad1a"
  end

  def install
    # Build the persistent PTY helper from source instead of embedding the prebuilt npm binary
    (buildpath/"ghostty").install resource("ghostty")
    ENV["GHOSTTY_SOURCE_DIR"] = buildpath/"ghostty"
    cd "ghostty" do
      system "zig", "fetch", resource("aro").cached_download
    end
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

    generate_completions_from_executable(bin/"opencode", shell_parameter_format: "--completions=")
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