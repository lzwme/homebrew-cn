class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://ghfast.top/https://github.com/jaymzh/sugarjar/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "abccb802954dbf1cf37941516e3f750c64d56f24c99a730585c49609135f3456"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "d3b0cff1f4580225d6a3e7eac8c851309a4b7a634608dde778093d5f84319439"
    sha256 cellar: :any, arm64_sequoia: "83694e0b651543ea1b51ce0311b93ff03574bffcaab978de7bbd6704b6841ff9"
    sha256 cellar: :any, arm64_sonoma:  "443c66a932d97244812ab60754d2051e56f145c321f0e2caa9ccb3ced226cc51"
    sha256 cellar: :any, sonoma:        "cb2dd88eb42cb99ab3b015b8a29e046148b6e8afc39b6d5647b4b9d52fda5e25"
    sha256 cellar: :any, arm64_linux:   "8c70dca9d32ea5845a28baf1ed56a7b81d064b8bed430a0e03f06a5fca11ca3b"
    sha256 cellar: :any, x86_64_linux:  "1d175b8ff9dfcc10e818bcf6ea390d6a02cd2b3fb1b33079603b009d740875f6"
  end

  depends_on "gh"
  depends_on "glab"
  depends_on "ruby"

  uses_from_macos "libffi"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/sj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    bash_completion.install "extras/sugarjar_completion.bash" => "sj"

    # Remove mkmf.log files to avoid shims references
    rm libexec.glob("extensions/*/*/*/mkmf.log")
  end

  test do
    output = shell_output("#{bin}/sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}/sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end