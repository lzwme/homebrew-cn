class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/crystal-lang/crystal/archive/1.10.0.tar.gz"
    sha256 "91e24e4bcfdd49a1c297622bd1348b336116c4a5ec4286ca6705281c0e874830"

    resource "shards" do
      url "https://ghproxy.com/https://github.com/crystal-lang/shards/archive/v0.17.3.tar.gz"
      sha256 "6512ff51bd69057f4da4783eb6b14c29d9a88b97d35985356d1dc644a08424c7"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e111bdc9707cc71a2813e051941ccfe6f4cd279e36e8a0b046b81f9ec0c7c6db"
    sha256 cellar: :any,                 arm64_ventura:  "1aa797a8b476bfe0d26e5ffaa499b2b4f282a1c2cfe7acec5d1372561030b62b"
    sha256 cellar: :any,                 arm64_monterey: "5e50a7e7e890e6ebdf789f049688001fb860e65f5fe40937affdbeb50d10ae8c"
    sha256 cellar: :any,                 sonoma:         "dc90da9c9e44d59acd667671db5497cb7ed691ecba83208c8f54f2943a2ec373"
    sha256 cellar: :any,                 ventura:        "a39d8db5ef6fb0a80b4f964ce7bb2548b36960e769a36136b3a93b2a9b7e2f47"
    sha256 cellar: :any,                 monterey:       "031ad387753e1ff1dd0de0863114a5bca849b6fd8fe4a009889dc6cf936ef9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bc173fb95aa6782414a8f5121464d853eb7fffe065f142cad7791329d30c6d1"
  end

  head do
    url "https://github.com/crystal-lang/crystal.git", branch: "master"

    uses_from_macos "libffi"  # for the interpreter

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git", branch: "master"
    end
  end

  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@15"
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
  # See: https://github.com/Homebrew/homebrew-core/pull/81318
  resource "boot" do
    boot_version = Version.new("1.5.1-1")
    version boot_version

    on_macos do
      url "https://ghproxy.com/https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-darwin-universal.tar.gz"
      # version boot_version
      sha256 "432c2fc992247f666db7e55fb15509441510831a72beba34affa2d76b6f2e092"
    end

    on_linux do
      on_intel do
        url "https://ghproxy.com/https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-linux-x86_64.tar.gz"
        # version boot_version
        sha256 "a475c3d99dbe0f2d5a72d471fa25e03c124b599e47336eed746973b4b4d787bc"
      end
    end
  end

  # Check version in `shard.lock` in shards repo.
  resource "molinillo" do
    url "https://ghproxy.com/https://github.com/crystal-lang/crystal-molinillo/archive/refs/tags/v0.2.0.tar.gz"
    sha256 "e231cf2411a6a11a1538983c7fb52b19e650acc3338bd3cdf6fdb13d6463861a"
  end

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    non_keg_only_runtime_deps = deps.reject(&:build?)
                                    .map(&:to_formula)
                                    .reject(&:keg_only?)

    resource("boot").stage "boot"
    ENV.append_path "PATH", "boot/bin"
    ENV["LLVM_CONFIG"] = llvm.opt_bin/"llvm-config"
    ENV["CRYSTAL_LIBRARY_PATH"] = ENV["HOMEBREW_LIBRARY_PATHS"]
    ENV.append_path "CRYSTAL_LIBRARY_PATH", MacOS.sdk_path_if_needed/"usr/lib" if MacOS.sdk_path_if_needed
    non_keg_only_runtime_deps.each do |dep|
      # Our just built `crystal` won't link with some dependents (e.g. `bdw-gc`, `libevent`)
      # unless they're explicitly added to `CRYSTAL_LIBRARY_PATH`. The keg-only dependencies
      # are already in `HOMEBREW_LIBRARY_PATHS`, so there is no need to add them.
      ENV.prepend_path "CRYSTAL_LIBRARY_PATH", dep.opt_lib
    end

    crystal_install_dir = bin
    stdlib_install_dir = pkgshare

    # Avoid embedding HOMEBREW_PREFIX references in `crystal` binary.
    config_library_path = "\\$$ORIGIN/#{HOMEBREW_PREFIX.relative_path_from(crystal_install_dir)}/lib"
    config_path = "\\$$ORIGIN/#{stdlib_install_dir.relative_path_from(crystal_install_dir)}/src"

    release_flags = ["release=true", "FLAGS=--no-debug"]
    crystal_build_opts = release_flags + [
      "CRYSTAL_CONFIG_LIBRARY_PATH=#{config_library_path}",
      "CRYSTAL_CONFIG_PATH=#{config_path}",
      "interpreter=true",
    ]
    crystal_build_opts << "CRYSTAL_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}" if build.head?

    # Build crystal
    (buildpath/".build").mkpath
    system "make", "deps"
    system "make", "crystal", *crystal_build_opts

    # Build shards (with recently built crystal)
    resource("shards").stage do
      require "yaml"

      shard_lock = YAML.load_file("shard.lock")
      required_molinillo_version = shard_lock.dig("shards", "molinillo", "version")
      available_molinillo_version = resource("molinillo").version.to_s
      odie "`molinillo` resource is outdated!" if required_molinillo_version != available_molinillo_version

      resource("molinillo").stage "lib/molinillo"

      shards_build_opts = release_flags + [
        "CRYSTAL=#{buildpath}/bin/crystal",
        "SHARDS=false",
      ]
      shards_build_opts << "SHARDS_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}" if build.head?
      system "make", "bin/shards", *shards_build_opts

      # Install shards
      bin.install "bin/shards"
      man1.install "man/shards.1"
      man5.install "man/shard.yml.5"
    end

    # Install crystal
    crystal_install_dir.install ".build/crystal"
    stdlib_install_dir.install "src"

    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"
    fish_completion.install "etc/completion.fish" => "crystal.fish"

    man1.install "man/crystal.1"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end