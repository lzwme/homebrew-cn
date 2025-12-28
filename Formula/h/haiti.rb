class Haiti < Formula
  desc "Hash type identifier"
  homepage "https://noraj.github.io/haiti/#/"
  url "https://ghfast.top/https://github.com/noraj/haiti/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "f6b8bf21104cedda21d1cdfa9931b5f7a6049231aedba984a0e92e49123a3791"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa443195d86019eb3dbf68c67289d5fcc9310844d968f16f8f064973942df8d9"
    sha256 cellar: :any,                 arm64_sequoia: "def333e10a42ff0a31ff160cf9baeaec0f4d51c865595f126fac3535762fc229"
    sha256 cellar: :any,                 arm64_sonoma:  "c448f3eada543dc9614cd076b2e26ff11f28afe2afcde76668ffb7e8ae5d0887"
    sha256 cellar: :any,                 sonoma:        "9a8ddd511fc386df87826a4c665082cf9e93d8fe7c1fd85e790d5eee01600abf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a99cdc8ea6ccbfb5094d92a33343e386251c33150bbf23943bd2bf76bf711c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373d6c82d524c8a543942e39fc466d61672457e5ec7a924927afa7bd3dfbb4d7"
  end

  depends_on "rust" => :build # for commonmarker
  depends_on "ruby"

  uses_from_macos "llvm" # for libclang

  def install
    # Support Ruby 4.x.x and Bundler 4.x.x
    # Upstrem PR ref: https://github.com/noraj/haiti/pull/229
    inreplace "Gemfile", "'bundler', '~> 2.1'", "'bundler', '>= 2.1'"
    inreplace "#{name}.gemspec", "'>= 3.1.0', '< 4.0'", "'>= 3.1.0', '< 5.0'"

    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec
    ENV["RB_SYS_FORCE_INSTALL_RUST_TOOLCHAIN"] = "false" # Avoid installing rustup

    # commonmarker fails to build with parallel jobs
    ENV.deparallelize { system "bundle", "install" }
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-hash-#{version}.gem"

    bin.install Dir[libexec/"bin/#{name}"]
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match version.to_s, shell_output("#{bin}/haiti --version")

    output = shell_output("#{bin}/haiti 12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4")
    assert_match "[JtR: raw-sha256]", output
  end
end