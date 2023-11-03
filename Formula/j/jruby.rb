class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.5.0/jruby-dist-9.4.5.0-bin.tar.gz"
  sha256 "a40f78c4641ccc86752e16b2da247fd6bc9fbcf9a4864cf1be36f7ff7b35684c"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e02b144ff52505b1a34302daaa584085a4a535e9f09202615af39302acc2722c"
    sha256 cellar: :any,                 arm64_ventura:  "e02b144ff52505b1a34302daaa584085a4a535e9f09202615af39302acc2722c"
    sha256 cellar: :any,                 arm64_monterey: "e02b144ff52505b1a34302daaa584085a4a535e9f09202615af39302acc2722c"
    sha256 cellar: :any,                 sonoma:         "037647d4a8dd08fdc6532c4c3f81219db49648d5fe0486b3b8f8f70ebb01d068"
    sha256 cellar: :any,                 ventura:        "037647d4a8dd08fdc6532c4c3f81219db49648d5fe0486b3b8f8f70ebb01d068"
    sha256 cellar: :any,                 monterey:       "037647d4a8dd08fdc6532c4c3f81219db49648d5fe0486b3b8f8f70ebb01d068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873a1cb5ebd23fc2a03728c4d5523746f49b10fe504a1f14c75e010c91539aaf"
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