class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://ghproxy.com/https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.38.tar.gz"
  sha256 "ec905d1b6590a250e7478e700bffa82c9787e46a6c7fa617013be19b993882d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "915bcf68de515b1820af1b1b38a742744a7637bd287deaaa5ff237d0874ebbb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51b8d3cbf4b33b73f4bb040d8c371627e99f063c50be65bd3df8071d33765382"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1327554dd7db8102bc831ed8311a3c627c8dbe008a0e364c3424be8a95aa8212"
    sha256 cellar: :any_skip_relocation, ventura:        "69d06021a18b25317e3ba8b05580fd79a29f37600ee820945fa679085cc59d6a"
    sha256 cellar: :any_skip_relocation, monterey:       "99542bcc61f7fc7211b16f9cdd5efabc62aa21a0b325433deec9d72e0f3c3355"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc2f7660bd88e4ea78b23164ce54e42b9097dd5cce12bf88ffb84174cab9a985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64bb0ae9aa85303336a1d7aed96b1f005cdabfdbc178e704ecb85523889583de"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end