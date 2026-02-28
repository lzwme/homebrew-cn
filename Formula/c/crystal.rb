class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://ghfast.top/https://github.com/crystal-lang/crystal/archive/refs/tags/1.19.1.tar.gz"
    sha256 "2f9cfaa6bdc872f6e89d483cfe474f35232e5dd4a33dcc05ec69e5fadb2b0257"

    resource "shards" do
      url "https://ghfast.top/https://github.com/crystal-lang/shards/archive/refs/tags/v0.20.0.tar.gz"
      sha256 "8655b87761016409e4411056e350b24e7fe79eae3f227b3354b181a03f14d5da"
    end

    # Backport support for LLVM 22
    patch do
      url "https://github.com/crystal-lang/crystal/commit/710d9a5eabd99a23534aa9c9cfde8e1c119d8730.patch?full_index=1"
      sha256 "e9a8c66d2de582cf85f4ff713592cd58a2e772cc8764857fab74aa2a57cd44bb"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e12ff8299d252518e4124e56ecc4cdb48ef0153d08c75715f7bcb076c8a2a0b"
    sha256 cellar: :any,                 arm64_sequoia: "731fd73bd657516829c34e0228066ccec8563a55543ee3e2cb2bcef38facbaa3"
    sha256 cellar: :any,                 arm64_sonoma:  "85a87d697edec5fcfeb78bfa899e213079e9de377de5b7cef7a416ad39e9e937"
    sha256 cellar: :any,                 sonoma:        "44a252cb01c1de8c5f7d22119ecaee4dbecc6b62d550364d5c3ee3d43a72971a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23fb74f2869d8a7a111c32490076c5042d6307ce85bf4eb540ea32e9cc8a13eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6114a8ba26bcae0bd6fc50468f9eeb217df1a245be1a2ee49eadf634e3f27e82"
  end

  head do
    url "https://github.com/crystal-lang/crystal.git", branch: "master"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git", branch: "master"
    end
  end

  depends_on "bdw-gc"
  depends_on "gmp" => :no_linkage # std uses it but it's not linked
  depends_on "libffi" # for the interpreter
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "openssl@3" # std uses it but it's not linked
  depends_on "pcre2"
  depends_on "pkgconf" # @[Link] will use pkg-config if available

  # It used to be the case that every new crystal release was built from a
  # previous release, except patches. Crystal is updating its policy to
  # allow 4 minor releases of compatibility unless otherwise specified.
  # Therefore, the boot version should have the MINOR component be
  # between the current minor - 4 and current minor - 1.
  #
  # See: https://github.com/Homebrew/homebrew-core/pull/81318
  resource "boot" do
    boot_version = Version.new("1.18.2-1")
    version boot_version

    on_macos do
      url "https://ghfast.top/https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-darwin-universal.tar.gz"
      # version boot_version
      sha256 "f61620ac389d640d4d429d114c725d6d53df27f0a3e54af25beb398a5815d6db"
    end

    on_linux do
      on_arm do
        url "https://ghfast.top/https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-linux-aarch64.tar.gz"
        # version boot_version
        sha256 "4bc44af4d9eedff2980b62d57bd0cbc111dd68f5b5b5df22751056aca59948c6"
      end
      on_intel do
        url "https://ghfast.top/https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-linux-x86_64.tar.gz"
        # version boot_version
        sha256 "de73134563db840791bc85bacd4e7f1360dc9c04af6e32a9b104300c561716b6"
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

    resource("boot").stage "boot"
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