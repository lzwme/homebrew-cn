class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.03.06.tar.gz"
  sha256 "320a7e30fc57559bcbe3f02ba3b2894deb1cd9cdf4a3d173427f24289b79210e"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "0146770cd44dfdbcb6e1bf463a26851ff04f912d47ddc3d70746cdd5947e378d"
    sha256 arm64_ventura:  "1a13d83bb356c06447511edcc2aed47c07e1e69a231503630fd351d960915912"
    sha256 arm64_monterey: "f21b5d367ee01612e033cca16a85e5cf1e0f6cd4d5419b35d55ef73c4ef4bb59"
    sha256 sonoma:         "031d1946fd4c3977a45988bb16b25201389e216c14876746f86866e698aa6a38"
    sha256 ventura:        "d138a73ae7df843aa1be522d897f5fd9d1809dbc5a2e756eb1174eba23e5e54c"
    sha256 monterey:       "50ea8ec787a6211bdad39c3149607347f63bbab2b96478c598b059c8cd510990"
    sha256 x86_64_linux:   "9c0dd66c190d85da5660ad9f13707e240eaccd51f6ebf1af1c56f26d9f6f8568"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end