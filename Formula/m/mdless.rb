class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https:github.comttscoffmdless"
  url "https:github.comttscoffmdlessarchiverefstags2.1.39.tar.gz"
  sha256 "ea492765c9dd5bed75063cfbd21620463539f6986d0998ac60bf9191e9a797d0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44f02bd30e5d442126de6ebf23d67b94d41748c5e038de47e819b07b32d3e78d"
    sha256 cellar: :any,                 arm64_ventura:  "a1a093304c7caccd79649071eba9c8a09e94f51d949e4fa074ed1190d11a2f24"
    sha256 cellar: :any,                 arm64_monterey: "3aba4b9fcb531801bd322caf6c0975b5470ec086c72d21be090bcac2d6bf54eb"
    sha256 cellar: :any,                 sonoma:         "4898e955de3e1d0297172056c92f41724698bd177cd1b549a180e5361b2bfb33"
    sha256 cellar: :any,                 ventura:        "980eae33be9f470fada239c688b1d5965c6018940a09501f8918a3ab64f90842"
    sha256 cellar: :any,                 monterey:       "25d16aa713d4268ffddc633ab478eed18cdf311e6be4b3f3f6444ad8d5d77e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95ad773ee15825cf6d997396b8c8aeecad6aa6505c0278d9ab4de526af29c89f"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}mdless --version")
    (testpath"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}mdless --no-color -P test.md")
    assert_match(^title first level =+$, out)
    assert_match(^title second level -+$, out)
  end
end