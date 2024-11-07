class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:github.comowasp-noirnoir"
  url "https:github.comowasp-noirnoirarchiverefstagsv0.18.2.tar.gz"
  sha256 "1ecd5ae543df771fa67bbb41a7c8cb416861f55988d120371a992a95f11dc27b"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "6a1974fbd1a4ecf439f5ae9591c9ccc52147d1ad34034c123eb68f635801402f"
    sha256 arm64_sonoma:  "dd82332d2f630e54dc04c9e42b1cbb52dd9c80fefeb1fac9ee58ea75f2dc044a"
    sha256 arm64_ventura: "691ca34d216d72d7f82688b29aedc6009314387cb22b2e6f5d870489d21e69bb"
    sha256 sonoma:        "157dfc631a275691db9a46fae6b259282ef5c0c04df02e90c5a774072e650179"
    sha256 ventura:       "77da359171406f6dde5b3b92dab63cac765dc70ec44e96dcd5c043c3ede663a6"
    sha256 x86_64_linux:  "1831940a88915457848b554fb440622612cee26e526dc3ab75d635c4a733349e"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "binnoir"

    generate_completions_from_executable(bin"noir", shell_parameter_format: "--generate-completion=",
                                                     shells:                 [:bash, :zsh, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}noir --version")

    system "git", "clone", "https:github.comowasp-noirnoir.git"
    output = shell_output("#{bin}noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end