class RubyAT31 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https:www.ruby-lang.org"
  url "https:cache.ruby-lang.orgpubruby3.1ruby-3.1.6.tar.gz"
  sha256 "0d0dafb859e76763432571a3109d1537d976266be3083445651dc68deed25c22"
  license "Ruby"

  livecheck do
    url "https:www.ruby-lang.orgendownloadsreleases"
    regex(href=.*?ruby[._-]v?(3\.1(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "7c2cfc1d13b3cf6f9d5f512c5db1671ac59a45587e801afffff865e563317591"
    sha256 arm64_sonoma:  "f56c01cd8d7cf4054fd95503f738e83e87cda639a0f9080441a753e8ccbc88df"
    sha256 arm64_ventura: "8ebbc78941564e92a8990b2835e142dc7c800f51968563215ebd8a896ff11292"
    sha256 sonoma:        "55ecb9dfb93f5e3627054c0b549e1c1a1c370c9722a0048d27383233df4168a8"
    sha256 ventura:       "04616b21752a8d3f7db1280cfb2ef995c1756fc9a604fb247b7e67637745fcde"
    sha256 arm64_linux:   "dcf541acf3a58e9627102fed214bbae1027093b97b8d6d612912493f69a7919c"
    sha256 x86_64_linux:  "1cbdd53137f42894eec9423fa7bd2b1d9849f7e15f2a9964c9b0e7ba7a9fd56f"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  # Should be updated only when Ruby is updated (if an update is available).
  # The exception is Rubygem security fixes, which mandate updating this
  # formula & the versioned equivalents and bumping the revisions.
  resource "rubygems" do
    url "https:rubygems.orgrubygemsrubygems-3.5.11.tgz"
    sha256 "4521b52f843620a9fc5ca7414526b7463b0989564c3ae80b26b68fbd1304c818"
  end

  def api_version
    "3.1.0"
  end

  def rubygems_bindir
    HOMEBREW_PREFIX"librubygems#{api_version}bin"
  end

  def install
    # otherwise `gem` command breaks
    ENV.delete("SDKROOT")

    # Prevent `make` from trying to install headers into the SDK
    # TODO: Remove this workaround when the following PR is mergedresolved:
    #       https:github.comHomebrewbrewpull12508
    inreplace "toolmkconfig.rb", ^(\s+val = )'"\$\(SDKROOT\)"'\+, "\\1"

    paths = %w[libyaml openssl@3 readline].map { |f| Formula[f].opt_prefix }
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-silent-rules
      --with-sitedir=#{HOMEBREW_PREFIX}librubysite_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}librubyvendor_ruby
      --with-opt-dir=#{paths.join(":")}
      --without-gmp
    ]
    args << "--disable-dtrace" if OS.mac? && !MacOS::CLT.installed?

    # Correct MJIT_CC to not use superenv shim
    args << "MJIT_CC=usrbin#{DevelopmentTools.default_compiler}"

    system ".configure", *args

    # Ruby has been configured to look in the HOMEBREW_PREFIX for the
    # sitedir and vendordir directories; however we don't actually want to create
    # them during the install.
    #
    # These directories are empty on install; sitedir is used for non-rubygems
    # third party libraries, and vendordir is used for packager-provided libraries.
    inreplace "toolrbinstall.rb" do |s|
      s.gsub! 'prepare "extension scripts", sitelibdir', ""
      s.gsub! 'prepare "extension scripts", vendorlibdir', ""
      s.gsub! 'prepare "extension objects", sitearchlibdir', ""
      s.gsub! 'prepare "extension objects", vendorarchlibdir', ""
    end

    system "make"
    system "make", "install"

    # A newer version of ruby-mode.el is shipped with Emacs
    elisp.install Dir["misc*.el"].reject { |f| f == "miscruby-mode.el" }

    if OS.linux?
      arch = Utils.safe_popen_read(
        bin"ruby", "-rrbconfig", "-e", 'print RbConfig::CONFIG["arch"]'
      ).chomp
      # Don't restrict to a specific GCC compiler binary we used (e.g. gcc-5).
      inreplace lib"ruby#{api_version}#{arch}rbconfig.rb" do |s|
        s.gsub! ENV.cxx, "c++"
        s.gsub! ENV.cc, "cc"
        # Change e.g. `CONFIG["AR"] = "gcc-ar-11"` to `CONFIG["AR"] = "ar"`
        s.gsub!((CONFIG\[".+"\] = )"(?:gcc|g\+\+)-(.*)-\d+", '\\1"\\2"')
      end
    end

    # This is easier than trying to keep both current & versioned Ruby
    # formulae repeatedly updated with Rubygem patches.
    resource("rubygems").stage do
      ENV.prepend_path "PATH", bin

      system bin"ruby", "setup.rb", "--prefix=#{buildpath}vendor_gem"
      rg_in = lib"ruby#{api_version}"
      rg_gems_in = lib"rubygems#{api_version}"

      # Remove bundled Rubygem and Bundler
      rm_r rg_in"bundler"
      rm rg_in"bundler.rb"
      rm_r Dir[rg_gems_in"gemsbundler-*"]
      rm Dir[rg_gems_in"specificationsdefaultbundler-*.gemspec"]
      rm_r rg_in"rubygems"
      rm rg_in"rubygems.rb"
      rm bin"gem"

      # Drop in the new version.
      rg_in.install Dir[buildpath"vendor_gemlib*"]
      (rg_gems_in"gems").install Dir[buildpath"vendor_gemgems*"]
      (rg_gems_in"specificationsdefault").install Dir[buildpath"vendor_gemspecificationsdefault*"]
      bin.install buildpath"vendor_gembingem" => "gem"
      (libexec"gembin").install buildpath"vendor_gembinbundle" => "bundle"
      (libexec"gembin").install_symlink "bundle" => "bundler"
    end
  end

  def post_install
    # Since Gem ships Bundle we want to provide that fullexpected installation
    # but to do so we need to handle the case where someone has previously
    # installed bundle manually via `gem install`.
    rm(%W[
      #{rubygems_bindir}bundle
      #{rubygems_bindir}bundler
    ].select { |file| File.exist?(file) })
    rm_r(Dir[HOMEBREW_PREFIX"librubygems#{api_version}gemsbundler-*"])
    rubygems_bindir.install_symlink Dir[libexec"gembin*"]

    # Customize rubygems to lookinstall in the global gem directory
    # instead of in the Cellar, making gems last across reinstalls
    config_file = lib"ruby#{api_version}rubygemsdefaultsoperating_system.rb"
    config_file.unlink if config_file.exist?
    config_file.write rubygems_config(api_version)

    # Create the sitedir and vendordir that were skipped during install
    %w[sitearchdir vendorarchdir].each do |dir|
      mkdir_p `#{bin}ruby -rrbconfig -e 'print RbConfig::CONFIG["#{dir}"]'`
    end
  end

  def rubygems_config(api_version)
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
            "#{api_version}"
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
          "#{opt_bin}ruby"
        end

        # https:github.comHomebrewhomebrew-coreissues40872#issuecomment-542092547
        # https:github.comHomebrewhomebrew-corepull48329#issuecomment-584418161
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
    hello_text = shell_output("#{bin}ruby -e 'puts :hello'")
    assert_equal "hello\n", hello_text

    assert_equal api_version, shell_output("#{bin}ruby -e 'print Gem.ruby_api_version'")

    ENV["GEM_HOME"] = testpath
    system bin"gem", "install", "json"

    (testpath"Gemfile").write <<~EOS
      source 'https:rubygems.org'
      gem 'github-markup'
    EOS
    system bin"bundle", "exec", "ls" # https:github.comHomebrewhomebrew-coreissues53247
    system bin"bundle", "install", "--binstubs=#{testpath}bin"
    assert_path_exists testpath"bingithub-markup", "github-markup is not installed in #{testpath}bin"
  end
end