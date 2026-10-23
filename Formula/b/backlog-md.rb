class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://ghfast.top/https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.55.2.tar.gz"
  sha256 "defd47f30b787a69bcf888499ea95ddd0ce6fc352c775a0b12010485b874b6c8"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "3dbe5db912a604600b595db4ea5eff9c4bae17d0518d14af566355dbbc21d046"
    sha256 arm64_tahoe:       "0fec6b716b16c86fcda9052ae79019dd23141d9e8b0837a172ea46058461c671"
    sha256 arm64_sequoia:     "049bb4b3475eaf936a753690b1d0e5af11018865deb1da8d1bd5bfc863bd6221"
    sha256 arm64_linux:       "ec488a930eaa285c3d559738a0a4293163d72ad429dec2e721b158e868b81455"
    sha256 x86_64_linux:      "090f24cdeb0bad75162ae79b37a826cde8bef716d6d856ab482aa22f185a0623"
  end

  depends_on "bun" => :build

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@78"
  end

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

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