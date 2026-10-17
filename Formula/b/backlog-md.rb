class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://ghfast.top/https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "da0bccce455a24c9486ea1cd7498ee9ec6011a6dab013934f52f5fc9a7f6b76f"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "11dfb718a8e10f06c3c1ee5abbe9cda87c5f576b7080fe4bf0df04cbbd600768"
    sha256 arm64_tahoe:       "a1ef86d43f13330147677aa7b79c0ed3c84b1808ff7e8059ab3fdf3415fdc97d"
    sha256 arm64_sequoia:     "debbde786d9617cd1f8dd3c0da49035b929534fdbc522ae9cbe44fde7a9aec3c"
    sha256 arm64_linux:       "d56de5d8e969b3d6bf7a5af891d5527daea95d645d83e7adf24f7c685159964e"
    sha256 x86_64_linux:      "37cc77d61e2a5a20af7bf643212e1445caf3646764e7e3b1ee505ac07ef32791"
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