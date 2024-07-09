class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https:easyengine.io"
  url "https:github.comEasyEngineeasyenginereleasesdownloadv4.7.2easyengine.phar"
  sha256 "2e09ea97f569395e919f72e6dd6d4fa6df778b840fb4702e656bf06a97a8308e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84949fe105ac220fba6490780a2b16d1e3e74a2357ba29ffd7e7f5a9ac67ff51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84949fe105ac220fba6490780a2b16d1e3e74a2357ba29ffd7e7f5a9ac67ff51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84949fe105ac220fba6490780a2b16d1e3e74a2357ba29ffd7e7f5a9ac67ff51"
    sha256 cellar: :any_skip_relocation, sonoma:         "88e66933fb668e5e1d0ef9458f4f705a65311fa1d47c84e8ce1b204be48dc60d"
    sha256 cellar: :any_skip_relocation, ventura:        "88e66933fb668e5e1d0ef9458f4f705a65311fa1d47c84e8ce1b204be48dc60d"
    sha256 cellar: :any_skip_relocation, monterey:       "88e66933fb668e5e1d0ef9458f4f705a65311fa1d47c84e8ce1b204be48dc60d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db4e86b2cf2e65481c9044b957b11f8dffbf22732f607baf86447fb61fe6ddd7"
  end

  depends_on "dnsmasq"
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `usrlocal` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "easyengine.phar" => "ee"
  end

  test do
    return if OS.linux? # requires `sudo`

    system bin"ee", "config", "set", "locale", "hi_IN"
    output = shell_output("#{bin}ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}ee cli info")
    assert_match OS.kernel_name, output
  end
end