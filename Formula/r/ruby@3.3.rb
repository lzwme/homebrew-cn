class RubyAT33 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https:www.ruby-lang.org"
  url "https:cache.ruby-lang.orgpubruby3.3ruby-3.3.7.tar.gz"
  sha256 "9c37c3b12288c7aec20ca121ce76845be5bb5d77662a24919651aaf1d12c8628"
  license "Ruby"

  livecheck do
    url "https:www.ruby-lang.orgendownloads"
    regex(href=.*?ruby[._-]v?(3\.3(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "ad47293ee871bb8726059a28d830de7a279c4da3b845845bc5f5307ee4adf083"
    sha256 arm64_sonoma:  "708e1361e0360ddc836296d49bf28ced8245be99fcb1d3e84bfee57e905e7efe"
    sha256 arm64_ventura: "c9dd0fed316b3b1593c6d191b8819c7434886776911eee1f1f0a8bc73f870b33"
    sha256 sonoma:        "6d87d4b89a56b48dd7288a54a8da1099161f78c52901b20d12ae1fbb5f284150"
    sha256 ventura:       "2c59ac608e05ea500300afe4e071a3a54e26c59c7f1a45de53babaae04261f32"
    sha256 arm64_linux:   "a80d1e7e0231236cb2faaa08e54fdee5b5697906119530a90365e5fe35ba73b4"
    sha256 x86_64_linux:  "8b03dbfb6086132a7adb0572148d90996122b4ac071040437b9d39d7f157cd1c"
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

  def determine_api_version
    Utils.safe_popen_read(bin"ruby", "-e", "print Gem.ruby_api_version")
  end

  def api_version
    if head?
      if latest_head_prefix
        determine_api_version
      else
        # Best effort guess
        "#{stable.version.major.to_i}.#{stable.version.minor.to_i + 1}.0+0"
      end
    else
      "#{version.major.to_i}.#{version.minor.to_i}.0"
    end
  end

  # Should be updated only when Ruby is updated (if an update is available).
  # The exception is Rubygem security fixes, which mandate updating this
  # formula & the versioned equivalents and bumping the revisions.
  resource "rubygems" do
    url "https:rubygems.orgrubygemsrubygems-3.6.3.tgz"
    sha256 "ed284c404da69a5fdb43c9d37b86e56f3c3f43a7bee85ac47cf2fb3a136f00ea"

    livecheck do
      url "https:rubygems.orgpagesdownload"
      regex(href=.*?rubygems[._-]v?(\d+(?:\.\d+)+)\.ti)
    end
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

    system ".autogen.sh" if build.head?

    paths = %w[libyaml openssl@3].map { |f| Formula[f].opt_prefix }
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-silent-rules
      --with-sitedir=#{HOMEBREW_PREFIX}librubysite_ruby
      --with-vendordir=#{HOMEBREW_PREFIX}librubyvendor_ruby
      --with-opt-dir=#{paths.join(":")}
      --without-gmp
    ]
    args << "--with-baseruby=#{RbConfig.ruby}" if build.head?
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

    return if build.head? # Use bundled RubyGems for --HEAD (will be newer)

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

    # remove all lockfiles in bin folder
    rm Dir[bin"*.lock"]
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

    assert_equal api_version, determine_api_version

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