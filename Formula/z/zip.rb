class Zip < Formula
  desc "Compression and file packagingarchive utility"
  homepage "https:infozip.sourceforge.netZip.html"
  url "https:downloads.sourceforge.netprojectinfozipZip%203.x%20%28latest%293.0zip30.tar.gz"
  version "3.0"
  sha256 "f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369"
  license "Info-ZIP"

  livecheck do
    url :stable
    regex(%r{url=.*?v?(\d+(?:\.\d+)+)zip\d+\.(?:t|zip)}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "525f3c06d55dd30c2c67b44f28070a53c258328b669ce3a36b8d12fb5d533750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99265457598a09b6312520471980b7b8429ebfef5be40d3e00a0980544ff12c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dcf7b9f3dd27efa70508ea258ccaa218e7c87fd9412b9ff15ac5814e3f3555d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eccd9c527ca597b460197f731bf726623475b239c9372267d8c667d8ac1b68e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bed17ac27c80c0553f32c572561660637547075e0c566f95805e2088e5945fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "db28293ae6aeac6f23a4d85f45358f3a618aa84c9934f1521e573a8461b8e52a"
    sha256 cellar: :any_skip_relocation, ventura:        "c35430007c35207c868add1c123dfa2833c31fcbdaff59c2af8b56ab0a284519"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5690223dfcc1683280d1692d3f41339981d9b4eacf68f3dedf9cd2cbc68ec1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac1760831eeaab6595e56b31f38d2c768de2e7c214a6f646a61ef16429a4b91"
    sha256 cellar: :any_skip_relocation, catalina:       "36f8c3138ed2e1110de5dc4c9ffd3616572ee1e4ec1ea63a3925f6c45e889e0d"
    sha256 cellar: :any_skip_relocation, mojave:         "16f22ea28d2c69d40772820c3e94c0a8510e6f05da4221ffd30b99b47fea5d7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "05abc07c9a205463418ad94534a9f36f1065555ef3dcf7494be5d77cb9bbd194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce503e630831ea12bb87e28c2668a185cb12a94680f4f42b791b6e4a19af2e87"
  end

  keg_only :provided_by_macos

  uses_from_macos "bzip2"

  # Upstream is unmaintained so we use the Debian patchset:
  # https:packages.debian.orgsidzip
  patch do
    url "https:deb.debian.orgdebianpoolmainzzipzip_3.0-11.debian.tar.xz"
    sha256 "c5c0714a88592f9e02146bfe4a8d26cd9bd97e8d33b1efc8b37784997caa40ed"
    apply %w[
      patches01-typo-it-is-transferring-not-transfering
      patches02-typo-it-is-privileges-not-priviliges
      patches03-manpages-in-section-1-not-in-section-1l
      patches04-do-not-set-unwanted-cflags
      patches05-typo-it-is-preceding-not-preceeding
      patches06-stack-markings-to-avoid-executable-stack
      patches07-fclose-in-file-not-fclose-x
      patches08-hardening-build-fix-1
      patches09-hardening-build-fix-2
      patches10-remove-build-date
    ]
  end

  # Fix compile with newer Clang
  # Otherwise configure thinks memset() and others are missing
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesd2b59930zipxcode15.diff"
    sha256 "99cb7eeeb6fdb8df700f40bfffbc30516c94774cbf585f725d81c3224a2c530c"
  end

  def install
    system "make", "-f", "unixMakefile", "CC=#{ENV.cc}", "generic"
    system "make", "-f", "unixMakefile", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath"test1").write "Hello!"
    (testpath"test2").write "Bonjour!"
    (testpath"test3").write "Moien!"

    system bin"zip", "test.zip", "test1", "test2", "test3"
    assert_path_exists testpath"test.zip"
    # zip -T needs unzip, disabled under Linux to avoid a circular dependency
    assert_match "test of test.zip OK", shell_output("#{bin}zip -T test.zip") if OS.mac?

    # test bzip2 support that should be automatically linked in using the bzip2 library in macOS
    system bin"zip", "-Z", "bzip2", "test2.zip", "test1", "test2", "test3"
    assert_path_exists testpath"test2.zip"
    # zip -T needs unzip, disabled under Linux to avoid a circular dependency
    assert_match "test of test2.zip OK", shell_output("#{bin}zip -T test2.zip") if OS.mac?
  end
end