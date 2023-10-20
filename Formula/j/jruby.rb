class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.4.0/jruby-dist-9.4.4.0-bin.tar.gz"
  sha256 "6ab12670afd8e5c8ac9305fabe42055795c5ddf9f8e8f1a1e60e260f2d724cc0"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "99797e2ae27d5c77c4097b1e02412384cfc3c7306c208eb5ff62ca0b48fed832"
    sha256 cellar: :any,                 arm64_ventura:  "99797e2ae27d5c77c4097b1e02412384cfc3c7306c208eb5ff62ca0b48fed832"
    sha256 cellar: :any,                 arm64_monterey: "99797e2ae27d5c77c4097b1e02412384cfc3c7306c208eb5ff62ca0b48fed832"
    sha256 cellar: :any,                 sonoma:         "207ec7daca3a7e1f3dcefbde02d7293787a9dde9cce43581e730a15be8d88feb"
    sha256 cellar: :any,                 ventura:        "207ec7daca3a7e1f3dcefbde02d7293787a9dde9cce43581e730a15be8d88feb"
    sha256 cellar: :any,                 monterey:       "207ec7daca3a7e1f3dcefbde02d7293787a9dde9cce43581e730a15be8d88feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59f9242a92b618a210e45cb9e5e92a8123804c64710dbc2794a8131489e2384"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast erb bundle bundler rake rdoc ri racc].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Remove incompatible libfixposix library
    os = OS.kernel_name.downcase
    if OS.linux?
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    end
    libfixposix_binary = libexec/"lib/ruby/stdlib/libfixposix/binary"
    libfixposix_binary.children
                      .each { |dir| dir.rmtree if dir.basename.to_s != "#{arch}-#{os}" }

    # Replace (prebuilt!) universal binaries with their native slices
    # FIXME: Build libjffi-1.2.jnilib from source.
    deuniversalize_machos
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end