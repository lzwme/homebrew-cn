class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https:crystal-lang.org"
  license "Apache-2.0"
  revision 1

  stable do
    url "https:github.comcrystal-langcrystalarchiverefstags1.15.1.tar.gz"
    sha256 "72b32f2da09059ca96331be124cf611d3c6bd6da80f52cd551df59bfe14e6ebd"

    resource "shards" do
      url "https:github.comcrystal-langshardsarchiverefstagsv0.19.1.tar.gz"
      sha256 "2a49e7ffa4025e0b3e8774620fa8dbc227d3d1e476211fefa2e8166dcabf82b5"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d1247ff0ad8af25afadbdfb5aa38db64f49aa6a90ed0fac08bda8e5e6f7c8bc"
    sha256 cellar: :any,                 arm64_sonoma:  "1688fc56e0148c8a6996ffa768eb805b3b4be7e1b876e9f557425729f9289c35"
    sha256 cellar: :any,                 arm64_ventura: "89ebc000727199878c0afa082ee5dfae8d294bcf03e81c76e3afdd20e35d13a6"
    sha256 cellar: :any,                 sonoma:        "b5243b486189f93a224fd53aebe580d5b1a558a10c23d81e520b4c258b44a029"
    sha256 cellar: :any,                 ventura:       "194d1b1a5ba564ffeec760e68e1e6d4d9a5d82b9fa706627a8257fb961d76c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e1d7a820bfbd6b571c06fac0be46e271ad781de6f151243f47af77534dc84d1"
  end

  head do
    url "https:github.comcrystal-langcrystal.git", branch: "master"

    resource "shards" do
      url "https:github.comcrystal-langshards.git", branch: "master"
    end
  end

  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@19"
  depends_on "openssl@3" # std uses it but it's not linked
  depends_on "pcre2"
  depends_on "pkgconf" # @[Link] will use pkg-config if available

  uses_from_macos "libffi" # for the interpreter

  on_linux do
    # There is no bootstrap compiler for arm64 Linux
    depends_on arch: :x86_64
  end

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
    non_keg_only_runtime_deps = deps.filter_map { |dep| dep.to_formula unless dep.build? }
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

    crystal_install_dir = OS.linux? ? libexec : bin
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

    return unless OS.linux?

    # Wrapper script so that Crystal can find libraries in HOMEBREW_PREFIX
    (bin"crystal").write_env_script(
      crystal_install_dir"crystal",
      LD_RUN_PATH: "${LD_RUN_PATH:+${LD_RUN_PATH}:}#{HOMEBREW_PREFIX}lib",
    )
  end

  test do
    assert_match "1", shell_output("#{bin}crystal eval puts 1")
  end
end