class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://byobu.org"
  url "https://ghfast.top/https://github.com/dustinkirkland/byobu/archive/refs/tags/7.20.tar.gz"
  sha256 "aa2563a0567f2c74e62d03b4a07bf7f1f005c88e8cf8007194c873c770371931"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4b89c3400932c3936e5b03ac1ce2d5ae2587d9532b14d2bfbbcf14a708b50a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4b89c3400932c3936e5b03ac1ce2d5ae2587d9532b14d2bfbbcf14a708b50a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4b89c3400932c3936e5b03ac1ce2d5ae2587d9532b14d2bfbbcf14a708b50a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8388a7612cd754dee31cfb8e579b5a0c5c11ccaecf948f3cff20da33affe1db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8388a7612cd754dee31cfb8e579b5a0c5c11ccaecf948f3cff20da33affe1db5"
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