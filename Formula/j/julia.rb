class Julia < Formula
  desc "Fast, Dynamic Programming Language"
  homepage "https:julialang.org"
  # Use the `-full` tarball to avoid having to download during the build.
  # TODO: Check if we can unbundle `curl`: https:github.comJuliaLangDownloads.jlissues260
  url "https:github.comJuliaLangjuliareleasesdownloadv1.11.1julia-1.11.1-full.tar.gz"
  sha256 "a49b804de6e86a03fe26c73f58851eaee1ff243d7204f2b5ae4dbc5c1dc2758d"
  license all_of: ["MIT", "BSD-3-Clause", "Apache-2.0", "BSL-1.0"]
  head "https:github.comJuliaLangjulia.git", branch: "master"

  # Upstream creates GitHub releases for both stable and LTS versions, so the
  # "latest" release on GitHub may be an LTS version instead of a "stable"
  # version. This checks the first-party download page, which links to the
  # `stable` tarballs from the newest releases on GitHub.
  livecheck do
    url "https:julialang.orgdownloads"
    regex(href=.*?julia[._-]v?(\d+(?:\.\d+)+)[._-]full\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b2539c87cfe9806329260581fc67be5bc2c86ea093e1e51a06ca180a11e31ed"
    sha256 cellar: :any,                 arm64_sonoma:  "4cc98c936169dcc782b9c25c33c2ed2970a15472c19196ece265c73c695f7d0e"
    sha256 cellar: :any,                 arm64_ventura: "030f65d72a6defa11b745578c309204e0524256ff4bdbf3dfba014abb28774d3"
    sha256 cellar: :any,                 sonoma:        "8729de1cbe4595e6410284e7806dbe32868cf1aa58b5aaec1b53e9f1f2836bd6"
    sha256 cellar: :any,                 ventura:       "4a84666af1dc53c87a29c6d717601626190f6137166d3029ecc060d7f54797d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c202ab099227ac14559c988c050b92a8a1a346c9796141e418839686fa05ebf8"
  end

  depends_on "cmake" => :build # Needed to build LLVM
  depends_on "gcc" => :build # for gfortran
  depends_on "ca-certificates"
  # Julia is currently incompatible with curl >= 8.10
  # Issue ref: https:github.comJuliaLangDownloads.jlissues260
  # TODO: depends_on "curl"
  depends_on "gmp"
  depends_on "libblastrampoline"
  depends_on "libgit2"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "mbedtls@2"
  depends_on "mpfr"
  depends_on "openblas"
  depends_on "openlibm"
  depends_on "p7zip"
  depends_on "pcre2"
  depends_on "suite-sparse"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "ncurses" # for terminfo
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
  end

  conflicts_with "juliaup", because: "both install `julia` binaries"

  # Link against libgcc_s.1.1.dylib, not libgcc_s.1.dylib
  # https:github.comJuliaLangjuliaissues48056
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches202ccbabd44bd5ab02fbdee2f51f87bb88d74417julialibgcc_s-1.8.5.diff"
    sha256 "1eea77d8024ad8bc9c733a0e0770661bc08228d335b20c4696350ed5dfdab29a"
  end

  def install
    # Build documentation available at
    # https:github.comJuliaLangjuliablobv#{version}docbuildbuild.md
    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      LOCALBASE=#{HOMEBREW_PREFIX}
      PYTHON=python3
      USE_BINARYBUILDER=0
      USE_SYSTEM_BLAS=1
      USE_SYSTEM_CSL=1
      USE_SYSTEM_CURL=0
      USE_SYSTEM_GMP=1
      USE_SYSTEM_LAPACK=1
      USE_SYSTEM_LIBBLASTRAMPOLINE=1
      USE_SYSTEM_LIBGIT2=1
      USE_SYSTEM_LIBSSH2=1
      USE_SYSTEM_LIBSUITESPARSE=1
      USE_SYSTEM_MBEDTLS=1
      USE_SYSTEM_MPFR=1
      USE_SYSTEM_NGHTTP2=1
      USE_SYSTEM_OPENLIBM=1
      USE_SYSTEM_P7ZIP=1
      USE_SYSTEM_PATCHELF=1
      USE_SYSTEM_PCRE=1
      USE_SYSTEM_UTF8PROC=1
      USE_SYSTEM_ZLIB=1
      VERBOSE=1
      LIBBLAS=-lopenblas
      LIBBLASNAME=libopenblas
      LIBLAPACK=-lopenblas
      LIBLAPACKNAME=libopenblas
      USE_BLAS64=0
      WITH_TERMINFO=0
    ]

    args << "MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    # Set MARCH and JULIA_CPU_TARGET to ensure Julia works on machines we distribute to.
    # Values adapted from https:github.comJuliaCIjulia-buildkiteblobmainutilitiesbuild_envs.sh
    args << "MARCH=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?

    cpu_targets = %w[generic]
    if Hardware::CPU.arm?
      if OS.mac?
        # For Apple Silicon, we don't care about other hardware
        cpu_targets << "apple-m1,clone_all"
      else
        cpu_targets += %w[cortex-a57 thunderx2t99 carmel,clone_all
                          apple-m1,base(3) neoverse-512tvb,base(3)]
      end
    end
    if Hardware::CPU.intel?
      cpu_targets += %w[sandybridge,-xsaveopt,clone_all
                        haswell,-rdrnd,base(1)
                        x86-64-v4,-rdrnd,base(1)]
    end
    args << "JULIA_CPU_TARGET=#{cpu_targets.join(";")}"
    user = begin
      tap.user
    rescue
      "unknown user"
    end
    args << "TAGGED_RELEASE_BANNER=Built by #{user} (v#{pkg_version})"

    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}julia"
    # Help Julia find keg-only dependencies
    deps.map(&:to_formula).select(&:keg_only?).map(&:opt_lib).each do |libdir|
      ENV.append "LDFLAGS", "-Wl,-rpath,#{libdir}"
    end

    gcc = Formula["gcc"]
    gcclibdir = gcc.opt_lib"gcccurrent"
    if OS.mac?
      ENV.append "LDFLAGS", "-Wl,-rpath,#{gcclibdir}"
      # List these two last, since we want keg-only libraries to be found first
      ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}lib"
      ENV.append "LDFLAGS", "-Wl,-rpath,usrlib" # Needed to find macOS zlib.
      ENV["SDKROOT"] = MacOS.sdk_path
    else
      ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}"
    end

    # Remove library versions from MbedTLS_jll, nghttp2_jll and others
    # https:git.archlinux.orgsvntogitcommunity.gittreetrunkjulia-hardcoded-libs.patch?h=packagesjulia
    %w[MbedTLS nghttp2 LibGit2 OpenLibm SuiteSparse].each do |dep|
      inreplace (buildpath"stdlib").glob("**#{dep}_jll.jl") do |s|
        s.gsub!(%r{@rpathlib(\w+)(\.\d+)*\.dylib}, "@rpathlib\\1.dylib")
        s.gsub!(lib(\w+)\.so(\.\d+)*, "lib\\1.so")
      end
    end

    # Make Julia use a CA cert from `ca-certificates`
    (buildpath"usrsharejulia").install_symlink Formula["ca-certificates"].pkgetc"cert.pem"

    # Workaround to install bundled curl without bundling other libs
    odie "Remove `make install-curl` workaround!" if deps.any? { |dep| dep.name == "curl" }
    system "make", "-C", "deps", "install-curl", *args

    system "make", *args, "install"

    if OS.linux?
      # Replace symlinks referencing Cellar paths with ones using opt paths
      deps.reject(&:build?).map(&:to_formula).map(&:opt_lib).each do |libdir|
        libdir.glob(shared_library("*")) do |so|
          next unless (lib"julia"so.basename).exist?

          ln_sf so.relative_path_from(lib"julia"), lib"julia"
        end
      end
    end

    # Create copies of the necessary gcc libraries in `buildpath"usrlib"`
    system "make", "-C", "deps", "USE_SYSTEM_CSL=1", "install-csl"
    # Install gcc library symlinks where Julia expects them
    gcclibdir.glob(shared_library("*")) do |so|
      next unless (buildpath"usrlib"so.basename).exist?

      # Use `ln_sf` instead of `install_symlink` to avoid referencing
      # gcc's full version and revision number in the symlink path
      ln_sf so.relative_path_from(lib"julia"), lib"julia"
    end

    # Some Julia packages look for libopenblas as libopenblas64_
    (lib"julia").install_symlink shared_library("libopenblas") => shared_library("libopenblas64_")

    # Keep Julia's CA cert in sync with ca-certificates'
    pkgshare.install_symlink Formula["ca-certificates"].pkgetc"cert.pem"
  end

  test do
    args = %W[
      --startup-file=no
      --history-file=no
      --project=#{testpath}
      --procs #{ENV.make_jobs}
    ]

    assert_equal "4", shell_output("#{bin}julia #{args.join(" ")} --print '2 + 2'").chomp

    if OS.linux? || Hardware::CPU.arm?
      # Setting up test suite is slow and causes Intel macOS to exceed 5 min limit
      with_env(CI: nil) do
        system bin"julia", *args, "--eval", 'Base.runtests("core")'
      end
    end

    # Check that installing packages works.
    # https:github.comorgsHomebrewdiscussions2749
    system bin"julia", *args, "--eval", 'using Pkg; Pkg.add("Example")'

    # Check that Julia can load stdlibs that load non-Julia code.
    # Most of these also check that Julia can load Homebrew-provided libraries.
    jlls = %w[
      MPFR_jll SuiteSparse_jll Zlib_jll OpenLibm_jll
      nghttp2_jll MbedTLS_jll LibGit2_jll GMP_jll
      OpenBLAS_jll CompilerSupportLibraries_jll dSFMT_jll LibUV_jll
      LibSSH2_jll LibCURL_jll libLLVM_jll PCRE2_jll
    ]
    system bin"julia", *args, "--eval", "using #{jlls.join(", ")}"

    # Check that Julia can load libraries in lib"julia".
    # Most of these are symlinks to Homebrew-provided libraries.
    # This also checks that these libraries can be loaded even when
    # the symlinks are broken (e.g. by version bumps).
    libs = (lib"julia").glob(shared_library("*"))
                        .map { |library| library.basename.to_s }
                        .reject do |name|
                          name.start_with?("sys", "libjulia-internal", "libccalltest")
                        end

    (testpath"library_test.jl").write <<~EOS
      using Libdl
      libraries = #{libs}
      for lib in libraries
        handle = dlopen(lib)
        @assert dlclose(handle) "Unable to close $(lib)!"
      end
    EOS
    system bin"julia", *args, "library_test.jl"
  end
end