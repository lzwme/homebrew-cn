class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https:www.genivia.comdocreflexhtml"
  url "https:github.comGeniviaRE-flexarchiverefstagsv5.1.0.tar.gz"
  sha256 "42bb511b6d7e12faf2972c4311534d3cca71cc84d2e9f3dd433e0eefb3b46fd1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c33ac4b00dee9b4f36faf9e6ff702cfa461d830391cd2e746a9e18bb5b7c3b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8ebceddddc1a6032b217a8f25de8720dc1fb5bcab270a4b3a19ed25037d874f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "192b93e6492764addb12a45a2f320b4bcbde46d3512534dee5cae7ebe1d4011a"
    sha256 cellar: :any_skip_relocation, sonoma:        "374feeaae05744f8ad8f7d9562fa8b7dd2c66dffea998f4bcd8dc3b7a1af6c46"
    sha256 cellar: :any_skip_relocation, ventura:       "ce34eb84a5ff9c117cb7c22e545b3924e54ed5e1690b984d38927b7513f4db56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "568e3e0f1d089018dabbc021e277f1e0221bfb96f9a5471bb83842c883e81f43"
  end

  depends_on "pcre2"

  conflicts_with "reflex", because: "both install `reflex` binaries"

  def install
    system ".configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath"echo.l").write <<~EOS
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system bin"reflex", "--flex", "echo.l"
    assert_predicate testpath"lex.yy.cpp", :exist?
  end
end