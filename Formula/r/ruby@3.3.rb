class RubyAT33 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.9.tar.gz"
  sha256 "d1991690a4e17233ec6b3c7844c1e1245c0adce3e00d713551d0458467b727b1"
  license "Ruby"
  revision 1

  livecheck do
    url "https://www.ruby-lang.org/en/downloads/"
    regex(/href=.*?ruby[._-]v?(3\.3(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "218fd8f200cefb6f890d4433ec7e882e3530367c541adf3119e4bd6bd4e6554b"
    sha256 arm64_sequoia: "978b3f43d041e8b00e8b32c52748b9f54779ea2adb43085e384b3037f71dbc66"
    sha256 arm64_sonoma:  "81b3985605a2b0993be1af51d035ec7c9765dc19cf49894f829d4254f40f4c08"
    sha256 sonoma:        "40cc48f77235c31136c27610e38d0708e67ab71a15c8afcdd3f3c24a971dfc5c"
    sha256 arm64_linux:   "688953c838f316e759a447be03139396188db355c148f20910438b7a70c5a0fb"
    sha256 x86_64_linux:  "6b25d1b4ee71ad2288ce113dc8bf25cb1842e731185401a984339b18245f32f3"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "openssl@3"

  uses_from_macos "gperf"
  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  # Should be updated only when Ruby is updated (if an update is available).
  # The exception is Rubygem security fixes, which mandate updating this
  # formula & the versioned equivalents and bumping the revisions.
  resource "rubygems" do
    url "https://rubygems.org/rubygems/rubygems-3.7.1.tgz"
    sha256 "750c8c771180d41ed2358344e5461edee83158c0a81b779969a1339961bc1163"

    livecheck do
      url "https://rubygems.org/pages/download"
      regex(/href=.*?rubygems[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
  end

  # Update the bundled openssl gem for compatibility with OpenSSL 3.6+
  # Using 3.2.x series to match major/minor version of bundled gem
  resource "openssl" do
    url "https://ghfast.top/https://github.com/ruby/openssl/archive/refs/tags/v3.2.2.tar.gz"
    sha256 "07b282b43090e9b223c7f1df54d5883851a63fa90faebcc4e18217a2e3c7faba"
  end

  def api_version
    "3.3.0"
  end

  def rubygems_bindir
    HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/bin"
  end

  def install
    openssl_gem_version = File.read("ext/openssl/openssl.gemspec")[/spec\.version\s*=\s*"(\d+(?:\.\d+)+)/, 1]
    odie "Remove openssl resource!" if Version.new(openssl_gem_version) >= "3.2.2"
    rm_r(%w[ext/openssl test/openssl])
    resource("openssl").stage do
      (buildpath/"ext").install "ext/openssl"
      (buildpath/"ext/openssl").install "lib", "History.md", "openssl.gemspec"
      (buildpath/"test").install "test/openssl"
    end

    # otherwise `gem` command breaks
    ENV.delete("SDKROOT")

    # Prevent `make` from trying to install headers into the SDK
    # TODO: Remove this workaround when the following PR is merged/resolved:
    #       https://github.com/Homebrew/brew/pull/12508
    inreplace "tool/mkconfig.rb", /^(\s+val = )'"\$\(SDKROOT\)"'\+/, "\\1"

    paths = %w[libyaml openssl@3].map { |f| Formula[f].opt_prefix }
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-silent-rules
      --with-sitedir=#{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}/lib/ruby/vendor_ruby
      --with-opt-dir=#{paths.join(":")}
      --without-gmp
    ]
    args << "--disable-dtrace" if OS.mac? && !MacOS::CLT.installed?

    # Correct MJIT_CC to not use superenv shim
    args << "MJIT_CC=/usr/bin/#{DevelopmentTools.default_compiler}"

    system "./configure", *args

    # Ruby has been configured to look in the HOMEBREW_PREFIX for the
    # sitedir and vendordir directories; however we don't actually want to create
    # them during the install.
    #
    # These directories are empty on install; sitedir is used for non-rubygems
    # third party libraries, and vendordir is used for packager-provided libraries.
    inreplace "tool/rbinstall.rb" do |s|
      s.gsub! 'prepare "extension scripts", sitelibdir', ""
      s.gsub! 'prepare "extension scripts", vendorlibdir', ""
      s.gsub! 'prepare "extension objects", sitearchlibdir', ""
      s.gsub! 'prepare "extension objects", vendorarchlibdir', ""
    end

    system "make"
    system "make", "install"

    # A newer version of ruby-mode.el is shipped with Emacs
    elisp.install Dir["misc/*.el"].reject { |f| f == "misc/ruby-mode.el" }

    if OS.linux?
      arch = Utils.safe_popen_read(
        bin/"ruby", "-rrbconfig", "-e", 'print RbConfig::CONFIG["arch"]'
      ).chomp
      # Don't restrict to a specific GCC compiler binary we used (e.g. gcc-5).
      inreplace lib/"ruby/#{api_version}/#{arch}/rbconfig.rb" do |s|
        s.gsub! ENV.cxx, "c++"
        s.gsub! ENV.cc, "cc"
        # Change e.g. `CONFIG["AR"] = "gcc-ar-11"` to `CONFIG["AR"] = "ar"`
        s.gsub!(/(CONFIG\[".+"\] = )"(?:gcc|g\+\+)-(.*)-\d+"/, '\\1"\\2"')
      end
    end

    # This is easier than trying to keep both current & versioned Ruby
    # formulae repeatedly updated with Rubygem patches.
    resource("rubygems").stage do
      ENV.prepend_path "PATH", bin

      system bin/"ruby", "setup.rb", "--prefix=#{buildpath}/vendor_gem"
      rg_in = lib/"ruby/#{api_version}"
      rg_gems_in = lib/"ruby/gems/#{api_version}"

      # Remove bundled Rubygem and Bundler
      rm_r rg_in/"bundler"
      rm rg_in/"bundler.rb"
      rm_r Dir[rg_gems_in/"gems/bundler-*"]
      rm Dir[rg_gems_in/"specifications/default/bundler-*.gemspec"]
      rm_r rg_in/"rubygems"
      rm rg_in/"rubygems.rb"
      rm bin/"gem"

      # Drop in the new version.
      rg_in.install Dir[buildpath/"vendor_gem/lib/*"]
      (rg_gems_in/"gems").install Dir[buildpath/"vendor_gem/gems/*"]
      (rg_gems_in/"specifications/default").install Dir[buildpath/"vendor_gem/specifications/default/*"]
      bin.install buildpath/"vendor_gem/bin/gem" => "gem"
      bin.install buildpath/"vendor_gem/bin/bundle" => "bundle"
      bin.install buildpath/"vendor_gem/bin/bundler" => "bundler"
    end

    # Customize rubygems to look/install in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib/"ruby/#{api_version}/rubygems/defaults/operating_system.rb"
    config_file.write rubygems_config
  end

  def post_install
    # Since Gem ships Bundle we want to provide that full/expected installation
    # but to do so we need to handle the case where someone has previously
    # installed bundle manually via `gem install`.
    rm(%W[
      #{rubygems_bindir}/bundle
      #{rubygems_bindir}/bundler
    ].select { |file| File.exist?(file) })
    rm_r(Dir[HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/gems/bundler-*"])
  end

  def rubygems_config
    <<~RUBY
      module Gem
        class << self
          alias :old_default_dir :default_dir
          alias :old_default_path :default_path
          alias :old_default_bindir :default_bindir
          alias :old_ruby :ruby
          alias :old_default_specifications_dir :default_specifications_dir
        end

        def self.default_dir
          path = [
            "#{HOMEBREW_PREFIX}",
            "lib",
            "ruby",
            "gems",
            RbConfig::CONFIG['ruby_version']
          ]

          @homebrew_path ||= File.join(*path)
        end

        def self.private_dir
          path = if defined? RUBY_FRAMEWORK_VERSION then
                   [
                     File.dirname(RbConfig::CONFIG['sitedir']),
                     'Gems',
                     RbConfig::CONFIG['ruby_version']
                   ]
                 elsif RbConfig::CONFIG['rubylibprefix'] then
                   [
                    RbConfig::CONFIG['rubylibprefix'],
                    'gems',
                    RbConfig::CONFIG['ruby_version']
                   ]
                 else
                   [
                     RbConfig::CONFIG['libdir'],
                     ruby_engine,
                     'gems',
                     RbConfig::CONFIG['ruby_version']
                   ]
                 end

          @private_dir ||= File.join(*path)
        end

        def self.default_path
          if Gem.user_home && File.exist?(Gem.user_home)
            [user_dir, default_dir, old_default_dir, private_dir]
          else
            [default_dir, old_default_dir, private_dir]
          end
        end

        def self.default_bindir
          "#{rubygems_bindir}"
        end

        def self.ruby
          "#{opt_bin}/ruby"
        end

        # https://github.com/Homebrew/homebrew-core/issues/40872#issuecomment-542092547
        # https://github.com/Homebrew/homebrew-core/pull/48329#issuecomment-584418161
        def self.default_specifications_dir
          File.join(Gem.old_default_dir, "specifications", "default")
        end
      end
    RUBY
  end

  def caveats
    <<~EOS
      By default, binaries installed by gem will be placed into:
        #{rubygems_bindir}

      You may want to add this to your PATH.
    EOS
  end

  test do
    hello_text = shell_output("#{bin}/ruby -e 'puts :hello'")
    assert_equal "hello\n", hello_text

    assert_equal api_version, shell_output("#{bin}/ruby -e 'print Gem.ruby_api_version'")

    ENV["GEM_HOME"] = testpath
    system bin/"gem", "install", "json"

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'github-markup'
    EOS
    system bin/"bundle", "exec", "ls" # https://github.com/Homebrew/homebrew-core/issues/53247
    system bin/"bundle", "install", "--binstubs=#{testpath}/bin"
    assert_path_exists testpath/"bin/github-markup", "github-markup is not installed in #{testpath}/bin"
  end
end