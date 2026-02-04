class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.0.3.0/jruby-dist-10.0.3.0-bin.tar.gz"
  sha256 "0edb5b02c3f482205d1cf8358f38e31d9e4c6d93a210039224750c72501e4717"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4783fa4522fff8ab6e18ce78a71fa442147f6978ee429eba8a9c59ad10f65295"
    sha256 cellar: :any,                 arm64_sequoia: "f5ce8335c6a3290e3c00494555cbf39b447804e6ff544572c7765449f235f445"
    sha256 cellar: :any,                 arm64_sonoma:  "f5ce8335c6a3290e3c00494555cbf39b447804e6ff544572c7765449f235f445"
    sha256 cellar: :any,                 sonoma:        "8437a84326e58721881f7c790687c9181f8d87f4b6f394d1bc8a270c90d5f405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac44cac0e6865a8f3c2e51bce0d0922d23a9277001ba046e876a1be927e547e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7f3b5501ef40ed646ad5ee00f0f2184765d2138fa3f483601b32de5aedc724"
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
    bin.install libexec.glob("bin/*")
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