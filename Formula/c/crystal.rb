class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"

  stable do
    # TODO: Replace arm64 linux bootstrap with official when available
    url "https://ghfast.top/https://github.com/crystal-lang/crystal/archive/refs/tags/1.17.0.tar.gz"
    sha256 "948b42ce690961e57cdf979e2ff2315ae23b3780344242499a893675625504c2"

    resource "shards" do
      url "https://ghfast.top/https://github.com/crystal-lang/shards/archive/refs/tags/v0.19.1.tar.gz"
      sha256 "2a49e7ffa4025e0b3e8774620fa8dbc227d3d1e476211fefa2e8166dcabf82b5"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f54e8edde6c99fb8f3b6fb2d0ad8d6f5b2e1b90c4f4d9c0167a4e5fdbd9c61d"
    sha256 cellar: :any,                 arm64_sonoma:  "3309f3897a21474b720b091ca6f5daf10548ee7710f6536829a18e5c4f2c4ee2"
    sha256 cellar: :any,                 arm64_ventura: "ad089985d19c30ae68cf67fe9e1605d975cb3fee13e6d9f0b47b252aa1dda26f"
    sha256 cellar: :any,                 sonoma:        "67c4bcc8c6f70a00f98b6bacb03b2d14abd66a58d065cd78ba7a78117cad6842"
    sha256 cellar: :any,                 ventura:       "3019801b09b19956772c59e4591f1ec500fa235a6d3d7eb2487ca570fdfd3ded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0af479befab36ff9f343f73cc4034e0dd95fb5c688743f290cc110b46174fd88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16cc8f3970c870c667c4755615855e82ed098e37e0bce75fc83dbfa137179687"
  end

  head do
    url "https://github.com/crystal-lang/crystal.git", branch: "master"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git", branch: "master"
    end
  end

  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "openssl@3" # std uses it but it's not linked
  depends_on "pcre2"
  depends_on "pkgconf" # @[Link] will use pkg-config if available

  uses_from_macos "libffi" # for the interpreter

  # It used to be the case that every new crystal release was built from a
  # previous release, except patches. Crystal is updating its policy to
  # allow 4 minor releases of compatibility unless otherwise specified.
  # Therefore, the boot version should have the MINOR component be
  # between the current minor - 4 and current minor - 1.
  #
  # See: https://github.com/Homebrew/homebrew-core/pull/81318
  resource "boot" do
    boot_version = Version.new("1.10.1-1")
    version boot_version

    on_macos do
      url "https://ghfast.top/https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-darwin-universal.tar.gz"
      # version boot_version
      sha256 "e6490e6d09745483bacea43c4d8974273632526c1f98f13db5aae0a5fc2c7924"
    end

    on_linux do
      on_arm do
        # NOTE: Since there are no official arm64 linux builds, we use the recommended[^1]
        # community-maintained builds. Upstream CI also uses 84codes docker images[^2].
        # The version used is 1.11.0 as there was an issue building with 1.10.1.
        #
        # [^1]: https://github.com/crystal-lang/crystal/issues/9833#issuecomment-1766007872
        # [^2]: https://github.com/crystal-lang/crystal/blob/master/.github/workflows/aarch64.yml#L70
        url "https://packagecloud.io/84codes/crystal/packages/any/any/crystal_1.11.0-124_arm64.deb/download.deb?distro_version_id=35"
        sha256 "fc42e49f703a9b60c81a87be67ea68726125cf7fddce2d4cafceb4324dca1ec8"
      end
      on_intel do
        url "https://ghfast.top/https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-linux-x86_64.tar.gz"
        # version boot_version
        sha256 "1742e3755d3653d1ba07c0291f10a517fa392af87130dba4497ed9d82c12348b"
      end
    end
  end

  # Check version in `shard.lock` in shards repo.
  resource "molinillo" do
    url "https://ghfast.top/https://github.com/crystal-lang/crystal-molinillo/archive/refs/tags/v0.2.0.tar.gz"
    sha256 "e231cf2411a6a11a1538983c7fb52b19e650acc3338bd3cdf6fdb13d6463861a"
  end

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    non_keg_only_runtime_deps = deps.filter_map { |dep| dep.to_formula unless dep.build? }
                                    .reject(&:keg_only?)

    if OS.linux? && Hardware::CPU.arm?
      resource("boot").stage do
        system "ar", "x", Dir["*.deb"].first
        system "tar", "xf", "data.tar.gz"
        (buildpath/"boot").install Dir["usr/*"]
      end
    else
      resource("boot").stage "boot"
    end
    ENV.append_path "PATH", "boot/bin"
    ENV["LLVM_CONFIG"] = llvm.opt_bin/"llvm-config"
    ENV["CRYSTAL_LIBRARY_PATH"] = ENV["HOMEBREW_LIBRARY_PATHS"]
    ENV.append_path "CRYSTAL_LIBRARY_PATH", MacOS.sdk_path_if_needed/"usr/lib" if OS.mac? && MacOS.sdk_path_if_needed
    non_keg_only_runtime_deps.each do |dep|
      # Our just built `crystal` won't link with some dependents (e.g. `bdw-gc`, `libevent`)
      # unless they're explicitly added to `CRYSTAL_LIBRARY_PATH`. The keg-only dependencies
      # are already in `HOMEBREW_LIBRARY_PATHS`, so there is no need to add them.
      ENV.prepend_path "CRYSTAL_LIBRARY_PATH", dep.opt_lib
    end

    crystal_install_dir = OS.linux? ? libexec : bin
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

    return unless OS.linux?

    # Wrapper script so that Crystal can find libraries in HOMEBREW_PREFIX
    (bin/"crystal").write_env_script(
      crystal_install_dir/"crystal",
      LD_RUN_PATH: "${LD_RUN_PATH:+${LD_RUN_PATH}:}#{HOMEBREW_PREFIX}/lib",
    )
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end