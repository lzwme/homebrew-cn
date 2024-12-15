class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.11.tar.gz"
  sha256 "5049a7ee42f1aac8d30816d0e02e64b6b40e06e3629233a584fb19802bc2870c"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3509fdd50f8e01ca7396f76a1beb78e406dff58d68074341137639ed27b4fe70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3509fdd50f8e01ca7396f76a1beb78e406dff58d68074341137639ed27b4fe70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3509fdd50f8e01ca7396f76a1beb78e406dff58d68074341137639ed27b4fe70"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e2c8f3f87f27d4ea65accfcefe0dc7e3bb0256d4bade01ccdb501cae32fdd4d"
    sha256 cellar: :any_skip_relocation, ventura:       "7e2c8f3f87f27d4ea65accfcefe0dc7e3bb0256d4bade01ccdb501cae32fdd4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3509fdd50f8e01ca7396f76a1beb78e406dff58d68074341137639ed27b4fe70"
  end

  def install
    inreplace_files = [
      "libexecgoenv",
      "pluginsgo-buildinstall.sh",
      "testgoenv.bats",
      "testtest_helper.bash",
    ]
    inreplace inreplace_files, "usrlocal", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}pluginsgo-buildbin#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}goenv help")
  end
end