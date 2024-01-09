class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https:crystal-lang.org"
  license "Apache-2.0"

  stable do
    url "https:github.comcrystal-langcrystalarchiverefstags1.11.0.tar.gz"
    sha256 "3c4eeb1191478770172a6fa7c4afb074526db9ecf0a80d434d1f4a6441414ae6"

    resource "shards" do
      url "https:github.comcrystal-langshardsarchiverefstagsv0.17.4.tar.gz"
      sha256 "3576c7418fa9fe09636f985a0043037bb84345f88e03ddb3da78dbe96683232d"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "02a731b574983076b0bdbd26f0729fd28ecc341f50e7b0c3c9065119061e25c0"
    sha256 cellar: :any,                 arm64_ventura:  "dcbaec0cc94739712da750eb05479c458ee6faeedf3c1a9b73c12006c90c366a"
    sha256 cellar: :any,                 arm64_monterey: "d596a7b779971f49cf99f37e72d4b9180e64715032f80489e85d641bc1dcdf2a"
    sha256 cellar: :any,                 sonoma:         "e4c012448c78ffdfdd29668e1a1f4fc40cfdd14b43009045b80131948efc7ecd"
    sha256 cellar: :any,                 ventura:        "80183e288e606146b920f51ed4c5391bc941a992786a392dfff70db135b6748a"
    sha256 cellar: :any,                 monterey:       "94c673910507ca32a0c868d469c834e4e2fd4810acbbb430c3ebdbeb71e9afad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfb66f18c0fd4b648db1dbdfbfbd542498786d1a27430c3eb37fd2d864d6877e"
  end

  head do
    url "https:github.comcrystal-langcrystal.git", branch: "master"

    uses_from_macos "libffi" # for the interpreter

    resource "shards" do
      url "https:github.comcrystal-langshards.git", branch: "master"
    end
  end

  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "openssl@3" # std uses it but it's not linked
  depends_on "pcre2"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  fails_with gcc: "5"

  # It used to be the case that every new crystal release was built from a
  # previous release, except patches. Crystal is updating its policy to
  # allow 4 minor releases of compatibility unless otherwise specified.
  # Therefore, the boot version should have the MINOR component be
  # between the current minor - 4 and current minor - 1.
  #
  # See: https:github.comHomebrewhomebrew-corepull81318
  resource "boot" do
    boot_version = Version.new("1.10.1-1")
    version boot_version

    on_macos do
      url "https:github.comcrystal-langcrystalreleasesdownload#{boot_version.major_minor_patch}crystal-#{boot_version}-darwin-universal.tar.gz"
      # version boot_version
      sha256 "e6490e6d09745483bacea43c4d8974273632526c1f98f13db5aae0a5fc2c7924"
    end

    on_linux do
      on_intel do
        url "https:github.comcrystal-langcrystalreleasesdownload#{boot_version.major_minor_patch}crystal-#{boot_version}-linux-x86_64.tar.gz"
        # version boot_version
        sha256 "1742e3755d3653d1ba07c0291f10a517fa392af87130dba4497ed9d82c12348b"
      end
    end
  end

  # Check version in `shard.lock` in shards repo.
  resource "molinillo" do
    url "https:github.comcrystal-langcrystal-molinilloarchiverefstagsv0.2.0.tar.gz"
    sha256 "e231cf2411a6a11a1538983c7fb52b19e650acc3338bd3cdf6fdb13d6463861a"
  end

  def install
    llvm = deps.find { |dep| dep.name.match?(^llvm(@\d+)?$) }
               .to_formula
    non_keg_only_runtime_deps = deps.reject(&:build?)
                                    .map(&:to_formula)
                                    .reject(&:keg_only?)

    resource("boot").stage "boot"
    ENV.append_path "PATH", "bootbin"
    ENV["LLVM_CONFIG"] = llvm.opt_bin"llvm-config"
    ENV["CRYSTAL_LIBRARY_PATH"] = ENV["HOMEBREW_LIBRARY_PATHS"]
    ENV.append_path "CRYSTAL_LIBRARY_PATH", MacOS.sdk_path_if_needed"usrlib" if OS.mac? && MacOS.sdk_path_if_needed
    non_keg_only_runtime_deps.each do |dep|
      # Our just built `crystal` won't link with some dependents (e.g. `bdw-gc`, `libevent`)
      # unless they're explicitly added to `CRYSTAL_LIBRARY_PATH`. The keg-only dependencies
      # are already in `HOMEBREW_LIBRARY_PATHS`, so there is no need to add them.
      ENV.prepend_path "CRYSTAL_LIBRARY_PATH", dep.opt_lib
    end

    crystal_install_dir = bin
    stdlib_install_dir = pkgshare

    # Avoid embedding HOMEBREW_PREFIX references in `crystal` binary.
    config_library_path = "\\$$ORIGIN#{HOMEBREW_PREFIX.relative_path_from(crystal_install_dir)}lib"
    config_path = "\\$$ORIGIN#{stdlib_install_dir.relative_path_from(crystal_install_dir)}src"

    release_flags = ["release=true", "FLAGS=--no-debug"]
    crystal_build_opts = release_flags + [
      "CRYSTAL_CONFIG_LIBRARY_PATH=#{config_library_path}",
      "CRYSTAL_CONFIG_PATH=#{config_path}",
      "interpreter=true",
    ]
    crystal_build_opts << "CRYSTAL_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}" if build.head?

    # Build crystal
    (buildpath".build").mkpath
    system "make", "deps"
    system "make", "crystal", *crystal_build_opts

    # Build shards (with recently built crystal)
    resource("shards").stage do
      require "yaml"

      shard_lock = YAML.load_file("shard.lock")
      required_molinillo_version = shard_lock.dig("shards", "molinillo", "version")
      available_molinillo_version = resource("molinillo").version.to_s
      odie "`molinillo` resource is outdated!" if required_molinillo_version != available_molinillo_version

      resource("molinillo").stage "libmolinillo"

      shards_build_opts = release_flags + [
        "CRYSTAL=#{buildpath}bincrystal",
        "SHARDS=false",
      ]
      shards_build_opts << "SHARDS_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}" if build.head?
      system "make", "binshards", *shards_build_opts

      # Install shards
      bin.install "binshards"
      man1.install "manshards.1"
      man5.install "manshard.yml.5"
    end

    # Install crystal
    crystal_install_dir.install ".buildcrystal"
    stdlib_install_dir.install "src"

    bash_completion.install "etccompletion.bash" => "crystal"
    zsh_completion.install "etccompletion.zsh" => "_crystal"
    fish_completion.install "etccompletion.fish" => "crystal.fish"

    man1.install "mancrystal.1"
  end

  test do
    assert_match "1", shell_output("#{bin}crystal eval puts 1")
  end
end