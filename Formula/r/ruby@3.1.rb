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
    sha256 arm64_sequoia:  "484f40a8b1a4b2762e2c689798d3f5677bb966f84864e2880749cd91926e9289"
    sha256 arm64_sonoma:   "7c5a047c339ba80d2a14b34ef244ed9e0af7102d340b8e5f91eca4d7a0a853bf"
    sha256 arm64_ventura:  "4440ac18c954c2f1d0cbfa0f470fb87c26ac1aa7a6734b83e87ab9d0ef630c7c"
    sha256 arm64_monterey: "0fdd2a2e9f8297ca292959540012c00392205312b865d1c7aeb18a09c16db428"
    sha256 sonoma:         "33a2ac7835348d4812760725fffeacdc1e6d15a5673b6230f2337196054e2b1e"
    sha256 ventura:        "20e409cb7b524b04e9248c9addb2e2d8a52027a8ddd3c07eb7e594b0e94fd2bf"
    sha256 monterey:       "015c58f56f84a419659b6e777683c9ac82d87cb3da3e428614ea63161e173084"
    sha256 x86_64_linux:   "a282cbc26752e31cc3957ee74991e08f6e12b736ecf41d5d56ff7435e8f6027c"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
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
    <<~EOS
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
    EOS
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
    assert_predicate testpath"bingithub-markup", :exist?, "github-markup is not installed in #{testpath}bin"
  end
end