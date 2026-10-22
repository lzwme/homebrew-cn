class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://ghfast.top/https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.55.1.tar.gz"
  sha256 "f4356cf9ce2f348b555d3ee228366b48a77df67d680ea37b49e2c781ebfb2523"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "d78871f60b2860518eedf90542430cc5c6a311f758bbd4294f1738b9fb651764"
    sha256 arm64_tahoe:       "2e40f85a8376a172da73e6874bee353780ae9add2ced8482878da05f10b79d00"
    sha256 arm64_sequoia:     "7994d04e4d8f3c29c385bd46ebd7fce44a0d8b75e3ae8a8a6759943792cf8780"
    sha256 arm64_linux:       "83ce80af778fea79a816159c327585606379f9e119240e8aac23741c72fd6abb"
    sha256 x86_64_linux:      "1de12b73c0edd7583fc9600910a6feba32dc1b3d6e05e7b2476019e816071882"
  end

  depends_on "bun" => :build

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@78"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"

    # Upstream injects the version at release time; the tagged `package.json` lags.
    ENV["BACKLOG_BUILD_VERSION"] = version.to_s

    # Not `bun run build`: that resolves `bun` from `node_modules/.bin`, and
    # `bun build --compile` embeds whichever runtime ran the build.
    system "bun", "scripts/build.ts"

    bin.install "dist/backlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end