class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://ghfast.top/https://github.com/jaymzh/sugarjar/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "abccb802954dbf1cf37941516e3f750c64d56f24c99a730585c49609135f3456"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c24e09c050d7729887c3299e6704df14debe539f8b3b588479987d27fd7cbab1"
    sha256 cellar: :any, arm64_sequoia: "4fe5d0c94d8cba6560c23a3bfb14a013c9dbd071cc7463f345c8a44d3b2fcf64"
    sha256 cellar: :any, arm64_sonoma:  "ac20983c555688bc31694896bbce74a540f3590b057d55abe743f3855056dada"
    sha256 cellar: :any, sonoma:        "cc26b3ddeac0543918008c402c83821d43d8b2eaa855853a81b8a9a1f2102d48"
    sha256 cellar: :any, arm64_linux:   "33b7e1cf0382e1b9ec1f2cb3ffaf81a47d6caec1ded38fd5e7723a82d1880f64"
    sha256 cellar: :any, x86_64_linux:  "8e8f4b87137d2c5e7b9e821a3f8acc5cd7b225adbb190565b42ca03bc5c6b7c4"
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