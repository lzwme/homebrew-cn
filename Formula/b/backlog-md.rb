class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://ghfast.top/https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "b8c23640a448f34af4b351769af1d45945a394a4c3a0116eb6ba768284ce5248"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "ead00f134b021487871aa767ccc7e1d52baa989d06d06e0a2f48e4f11558da69"
    sha256 arm64_tahoe:       "a385efa66dfc99eaebb1f25eedb6ab5c3f4f0b258a90a80b1fe33df4a90bc0b2"
    sha256 arm64_sequoia:     "bb9113816db429020a82530e116e554f0fa64fd4d7f41cbfe6f4ca0d8e662523"
    sha256 arm64_linux:       "9d10bd2b3e8868e4fa41481855442101212b4ac7959e50b84c34774650099959"
    sha256 x86_64_linux:      "07b0c53f0c399705ba33a198319cf2e6b5c5a69f4ff104a7461528db6977427a"
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