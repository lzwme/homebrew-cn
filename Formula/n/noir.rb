class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:github.comowasp-noirnoir"
  url "https:github.comowasp-noirnoirarchiverefstagsv0.18.3.tar.gz"
  sha256 "5173e62129afafeb6bb622b2a0ab45db9b2bb0781fad1258b6679f3bab3d69c2"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "747e63fa8cf8a20d6d2bd2e40af11d70a787de376d92669778982163f863b2e7"
    sha256 arm64_sonoma:  "285aaca5a309f0a5f9336016ab1269b409e723511e3b25454656ad47df28f77e"
    sha256 arm64_ventura: "5a84fb8f63013c45d6a406abbf5e50b2aca04331fa65ed8e956120edc548ba1a"
    sha256 sonoma:        "3bff904faa03844d84db4b617e55ae6d4d5a29afb775c3770c77f4ff0cc45688"
    sha256 ventura:       "a1ad7b130ad06390e8dc8a69043983cae847b1b2cc3ea93dc08366c29e05b916"
    sha256 x86_64_linux:  "73f691ad47d84104de788c4da63c6d5cb381acf54cc3c1d3634427efeb4d22c6"
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