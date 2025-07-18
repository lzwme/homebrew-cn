class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.0.1.0/jruby-dist-10.0.1.0-bin.tar.gz"
  sha256 "22174ed408aa19340fc3c609b67f5a83374539ecc50053153d60f6e1f81faa9d"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5af3f2893b11ba2200636a46b899f7347839dfa5b1bf9f2ee80306142995928a"
    sha256 cellar: :any,                 arm64_sonoma:  "5af3f2893b11ba2200636a46b899f7347839dfa5b1bf9f2ee80306142995928a"
    sha256 cellar: :any,                 arm64_ventura: "5af3f2893b11ba2200636a46b899f7347839dfa5b1bf9f2ee80306142995928a"
    sha256 cellar: :any,                 sonoma:        "090e9938da1305204560f062e8b597e4b2b21d238a954bef9a08f49e6c4bb2bf"
    sha256 cellar: :any,                 ventura:       "090e9938da1305204560f062e8b597e4b2b21d238a954bef9a08f49e6c4bb2bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a35c561d4f6ed2571852cf4cfb3414e8d7e404467c7469e251e880061bfbcd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fed66d203d1e412e314265250a76be3563324ad7ed42d709f49def1d77d8587"
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
    rm_r(Dir["lib/jni/*"] - ["lib/jni/Darwin"])
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
                      .each { |dir| rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}" }

    # Replace (prebuilt!) universal binaries with their native slices
    # FIXME: Build libjffi-1.2.jnilib from source.
    deuniversalize_machos
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end