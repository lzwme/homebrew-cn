class Ccmux < Formula
  desc "Run all your AI coding agents in tmux"
  homepage "https://github.com/epilande/ccmux"
  url "https://ghfast.top/https://github.com/epilande/ccmux/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "f19afae151a688b707a81f4d11d6a1b29e1320868a7fc0dd9672136518e9b92a"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "caee880be4e57938e0b7a059d4a059606892cc3811bee7696e7d7d6883b4cd27"
    sha256 arm64_tahoe:       "281f0f624d0cc5ef3f4d1dcbed9ecb617f1239ee5845a9e5a41759482b52daab"
    sha256 arm64_sequoia:     "f1b0ab051e1919fa5214a8a191a71a316b1e93566d66b31e88e8ad635064917e"
    sha256 arm64_linux:       "e214af63d3c6187931972919e46ea553d8ca90bec8d02ffb4313fe6a8c372a74"
    sha256 x86_64_linux:      "e08eb10ff4c1109f703b5cecc3816ebd5b2350caee1970cb19b7bec6b7d00178"
  end

  depends_on "bun" => :build
  depends_on "tmux"

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@78"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.start_with?("icu4c") }.to_formula
      icu = deps.find { |dep| dep.name.start_with?("icu4c") }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    system "bun", "run", "build"

    # Without this the executable inherits the repository's bunfig.toml, whose
    # `preload` needs node_modules that aren't present at runtime.
    system "bun", "build", "dist/index.js", "--compile", "--no-compile-autoload-bunfig",
           "--outfile", bin/"ccmux"

    generate_completions_from_executable(bin/"ccmux", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccmux --version")

    # Keep config and state out of the real home directory.
    ENV["CCMUX_HOME"] = testpath/"ccmux"

    system bin/"ccmux", "config", "set", "theme", "nord"
    assert_match '"theme": "nord"', (testpath/"ccmux/ccmux.json").read
    assert_match 'theme = "nord"', shell_output("#{bin}/ccmux config get theme")
  end
end