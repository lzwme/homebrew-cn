class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.03.05.tar.gz"
  sha256 "d060f4073fa7a498824dc5a00ab567c92025a7b5121e4651663a86ea787bcdd4"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "a9ea839ec27d51be27cda6526752b5d0de4bb70aedce4d1a289c32df036d51c0"
    sha256 arm64_tahoe:       "e90c5ffe8962780db2ad192be46d0b09cf761831b20ed74f0573f272ef9690aa"
    sha256 arm64_sequoia:     "a0dee26ab9291f7af8fea0519e0cb0d81b5337385f41a725856c1f4c01efd82e"
    sha256 arm64_linux:       "927d105cacc6aebcd6bf428d7455d6e5b7ab7e27940aa593b5809a8f62ecb5fd"
    sha256 x86_64_linux:      "eafa7f32df5f0d94cad08f00c97ba04ebdcb7fe8948d6e6d48be50a1b0b010cb"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  deny_network_access!

  def install
    # Exclude unrecognized options
    args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", *args
    system "make", "-C", "src", "install"
    system "make", "-C", "rem2html", "install"
  end

  test do
    (testpath/"reminders.rem").write <<~REM
      SET $OnceFile "./once.timestamp"
      REM ONCE 2015-01-01 MSG Homebrew Test
    REM
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders.rem 2015-01-01")
  end
end