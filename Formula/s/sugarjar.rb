class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://ghfast.top/https://github.com/jaymzh/sugarjar/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "7ae427d8dff1a293f063617365e76615ea7d238aaa7def260fd2b6f2cfa5e768"
  license "Apache-2.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7bf1fb7c778622b53a508daeb750b2db8111a2c4bba753d774887675e02ade1"
    sha256 cellar: :any,                 arm64_sequoia: "c84ec1f5ae6bff4f8dbd2b7e48586267ddc5ee1db8f40d7cc566a3a6e8b77b1f"
    sha256 cellar: :any,                 arm64_sonoma:  "62e9d53bb0f055c501e15c1d7b01b50bb5e380e6d76e2a764887eac948f0ccd6"
    sha256 cellar: :any,                 sonoma:        "de56c6a946f4e8ee98a7156fe97d25fcea6200db8f2132b56b3440365a798b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "015c56a4c20529943d38b59a371d7b01ad27696378c499934811ada3d4e4c6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0463a14f72f0bc96e494ec5731b25c3f75afb993df840566808e32195e9907d2"
  end

  depends_on "gh"
  depends_on "ruby"

  uses_from_macos "libffi"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/sj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    bash_completion.install "extras/sugarjar_completion.bash" => "sj"

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    output = shell_output("#{bin}/sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}/sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end