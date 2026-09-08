class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://ghfast.top/https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "aed59fa7f5f8309ab244a30bad1d954330e6ff049f2acdfa1498dc52a18fd914"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "eb57decb3b1de5df88dc92832e1f8396929c258fe0bde14567acf5dd5f5b8cfa"
    sha256 arm64_sequoia: "c54bf5dda10631fa7f6c6899292754fb5afb1f0dbe24386e420cf73ed69275d1"
    sha256 arm64_sonoma:  "f4dff80ede1da156a32fc46a3d3c01d5e20f5d9cf105b5ec56b3304bf8bdb2f8"
    sha256 arm64_linux:   "2c96408cd191b11f6707eb9e8b0f9619371b38c70b3a29c15944449c196ae7e6"
    sha256 x86_64_linux:  "d3f701c26ee211f13caaddcd32049fbd35f71c62524df9104f2e94722b71e0f6"
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