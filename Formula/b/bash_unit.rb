class BashUnit < Formula
  desc "Bash unit testing enterprise edition framework for professionals"
  homepage "https:github.compgrangebash_unit"
  url "https:github.compgrangebash_unitarchiverefstagsv2.3.0.tar.gz"
  sha256 "750983353e79ad83cb3ec093406be7306bd1d90a64f77977b29bb968d66731f6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c2b16b7d7957d69eed22673aba747a50356bd15e6ed3fa9e673f52932f8f7ca"
  end

  uses_from_macos "bc" => :test

  def install
    bin.install "bash_unit"
    man1.install "docsmanman1bash_unit.1"
  end

  test do
    (testpath"test.sh").write <<~EOS
      test_addition() {
        RES="$(echo 2+2 | bc)"
        assert_equals "${RES}" "4"
      }
    EOS
    assert "addition", shell_output("#{bin}bash_unit test.sh")
  end
end