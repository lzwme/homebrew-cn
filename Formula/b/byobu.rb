class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://byobu.org"
  url "https://ghfast.top/https://github.com/dustinkirkland/byobu/archive/refs/tags/7.21.tar.gz"
  sha256 "4d2836e528c9b3f6f761679badfecc085f4a05855337b4ee7772feceb444a08f"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70b60f7b7d40f324afbdc82ae51c8781a9e4b538faeb95b832e9ee093d2f08be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70b60f7b7d40f324afbdc82ae51c8781a9e4b538faeb95b832e9ee093d2f08be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70b60f7b7d40f324afbdc82ae51c8781a9e4b538faeb95b832e9ee093d2f08be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e5f14d0958691c11927a11802da4ab90c60443e30e0131dd7f4f3f171f248ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8e5f14d0958691c11927a11802da4ab90c60443e30e0131dd7f4f3f171f248ec"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "newt"
  depends_on "tmux"

  on_macos do
    depends_on "coreutils"
    depends_on "gettext"
  end

  conflicts_with "ctail", because: "both install `ctail` binaries"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize { system "make", "install" }

    byobu_python = Formula["newt"].deps
                                  .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                  .to_formula
                                  .libexec/"bin/python"

    lib.glob("byobu/include/*.py").each do |script|
      byobu_script = "byobu-#{script.basename(".py")}"

      libexec.install(bin/byobu_script)
      (bin/byobu_script).write_env_script(libexec/byobu_script, BYOBU_PYTHON: byobu_python)
    end
  end

  test do
    # Keep the tmux socket out of the shared `/tmp`, where the sandbox blocks connecting to stale ones
    ENV["TMUX_TMPDIR"] = testpath

    system bin/"byobu-status"
    assert_match "open terminal failed", shell_output("#{bin}/byobu-select-session 2>&1", 1)
  end
end