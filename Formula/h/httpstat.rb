class Httpstat < Formula
  include Language::Python::Shebang

  desc "Curl statistics made simple"
  homepage "https:github.comreorxhttpstat"
  url "https:github.comreorxhttpstatarchiverefstags1.3.2.tar.gz"
  sha256 "56c45aebdb28160dd16c73cf23af8208c19b30ec0166790685dfec115df9c92f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4c6ac7e7f5619376d294d7921048b7bfc2745c280518b2ce977f8091d5536ef9"
  end

  uses_from_macos "curl"
  uses_from_macos "python"

  def install
    if OS.linux? || MacOS.version >= :catalina
      rw_info = python_shebang_rewrite_info("usrbinenv python3")
      rewrite_shebang rw_info, "httpstat.py"
    end
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}httpstat https:github.com")
  end
end