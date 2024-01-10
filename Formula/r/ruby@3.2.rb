class RubyAT32 < Formula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https:www.ruby-lang.org"
  url "https:cache.ruby-lang.orgpubruby3.2ruby-3.2.2.tar.gz"
  sha256 "96c57558871a6748de5bc9f274e93f4b5aad06cd8f37befa0e8d94e7b8a423bc"
  license "Ruby"

  livecheck do
    url "https:www.ruby-lang.orgendownloads"
    regex(href=.*?ruby[._-]v?(3\.2(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "91b5c2d9207e9f58ad261b5f5840c34dc72f1a5eb6de01c3cedaf89e432ddfe3"
    sha256 arm64_ventura:  "0b65c4ba013503e416a4884712402cc2ed5c6b9f4c4560f86039fb2b71628e83"
    sha256 arm64_monterey: "2df167357dc100a1b762b41c0b1458bf28abc360ac0b83e4fc273c57c8b3a3f1"
    sha256 sonoma:         "8dfc8b566f6eef066982c219a54349745fe357b2ff25a1540ebb670ebb832993"
    sha256 ventura:        "95143e5b58e724722afaab652fa03a8d44dad295c7eeeca312f752459e79ddd3"
    sha256 monterey:       "cdab46842594d1697969df3dfaabe26447805c68dd64bdd437358f907595d428"
    sha256 x86_64_linux:   "69149c1e6132fe612f4b54f0e6e684632b24ec186b9aef6aa55cd23836423b26"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "gperf"
  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  # Should be updated only when Ruby is updated (if an update is available).
  # The exception is Rubygem security fixes, which mandate updating this
  # formula & the versioned equivalents and bumping the revisions.
  resource "rubygems" do
    url "https:rubygems.orgrubygemsrubygems-3.4.10.tgz"
    sha256 "55f1c67fa2ae96c9751b81afad5c0f2b3792c5b19cbba6d54d8df9fd821460d3"
  end

  def api_version
    "3.2.0"
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

      system "#{bin}ruby", "setup.rb", "--prefix=#{buildpath}vendor_gem"
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
    rm_f %W[
      #{rubygems_bindir}bundle
      #{rubygems_bindir}bundler
    ]
    rm_rf Dir[HOMEBREW_PREFIX"librubygems#{api_version}gemsbundler-*"]
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
    system "#{bin}gem", "install", "json"

    (testpath"Gemfile").write <<~EOS
      source 'https:rubygems.org'
      gem 'github-markup'
    EOS
    system bin"bundle", "exec", "ls" # https:github.comHomebrewhomebrew-coreissues53247
    system bin"bundle", "install", "--binstubs=#{testpath}bin"
    assert_predicate testpath"bingithub-markup", :exist?, "github-markup is not installed in #{testpath}bin"
  end
end