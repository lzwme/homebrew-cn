class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:github.comowasp-noirnoir"
  url "https:github.comowasp-noirnoirarchiverefstagsv0.18.1.tar.gz"
  sha256 "cbe5b90996b3878c6127424e086387858cdcd2037170dbe060bae834811de755"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "42ade1403dd5e04833e2918326a645d6a93d3dffe74e7489630533ce814261b7"
    sha256 arm64_sonoma:  "c2b2d2fb8849b81720df081fd372a6e09b0140942487a87aaad3c4509c3620d2"
    sha256 arm64_ventura: "951bf68a28ba4a36ffa3d7f8415a12d79ad4a438a081a601a3938e87b4766f7e"
    sha256 sonoma:        "cb7a269e2959bddbfff7a653b06f5646e0c35478e271737d5a0fef87c95cbf6f"
    sha256 ventura:       "5b6c3675e6ca638457bda64998e7ca8f14f58cba16bb7cb827338dd8214ad792"
    sha256 x86_64_linux:  "9b1b0912a0738340ba696ca79cb7f531a2581ddf57126582248c6b8037665e89"
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