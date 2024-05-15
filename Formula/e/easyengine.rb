class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https:easyengine.io"
  url "https:github.comEasyEngineeasyenginereleasesdownloadv4.7.0easyengine.phar"
  sha256 "cb08e6fe4b8691ee33d84ad773166cc778fc0e92d85d545f66d15f7425473d3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7b8ccf1b66f4770d67c1a7137afa75e5f479b237c82215d6c0014bf3861d521"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68b7a65d955be83ad4d0eb0b8f7105136a661321ed9eeb462eb1234ea7b89f5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d0d57fd269c77a51a472869d4cca083ef20ad7c9b85f59b2fe873357875b8da"
    sha256 cellar: :any_skip_relocation, sonoma:         "67faa99d20aa91bd4cd78c1803d5d2c1de1a4db9052049eb121af021a3a200cf"
    sha256 cellar: :any_skip_relocation, ventura:        "0e305d1f55a29d64ef7f1117c575305ae05d1eef983f97d8101eb3afdb0397b0"
    sha256 cellar: :any_skip_relocation, monterey:       "6825305c5439969c3d02731279470781512ea253b153ce8dc68ddf93e497061d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94111e9dff157554d0318006dba42ddbcc8578035aa180787bd79ad5593a1d54"
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