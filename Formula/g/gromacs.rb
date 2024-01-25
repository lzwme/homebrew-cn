class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2023.4.tar.gz"
  sha256 "e5d6c4d9e7ccacfaccb0888619bd21b5ea8911f82b410e68d6db5d40f695f231"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b9b9b73baaf04f0fd563737f07e0d0fd6f4ba9fbdf3b27be9fb133bb77a8a8a0"
    sha256 arm64_ventura:  "34c69ee261806095a8d11f21b2a89313c3158aa1bc5e589b3b1c9cda1354fb3c"
    sha256 arm64_monterey: "e3dcbac034c6a5232e01f0e2739b2855cf2bc226071d10df6b99b8731f285fb5"
    sha256 sonoma:         "2c3f8218361a732cc45d073ec917f7c7986ebf8c7f9953082b3c6e5ed3ff7d45"
    sha256 ventura:        "a4975768c49b59533d64c275454549146f8cd24137bef2c2e9e6d91947943331"
    sha256 monterey:       "4d7a0647ead87f2506c58519cf540fd8938f048189547edf724d80f1df44e784"
    sha256 x86_64_linux:   "059cc8163d220b82831f2b8beb85ddfeb5b090c3a4f7c9005026fb53382af48c"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "openblas"

  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

    # Avoid superenv shim reference
    gcc = Formula["gcc"]
    cc = gcc.opt_bin/"gcc-#{gcc.any_installed_version.major}"
    cxx = gcc.opt_bin/"g++-#{gcc.any_installed_version.major}"
    inreplace "src/gromacs/gromacs-hints.in.cmake" do |s|
      s.gsub! "@CMAKE_LINKER@", "/usr/bin/ld"
      s.gsub! "@CMAKE_C_COMPILER@", cc
      s.gsub! "@CMAKE_CXX_COMPILER@", cxx
    end

    inreplace "src/buildinfo.h.cmakein" do |s|
      s.gsub! "@BUILD_C_COMPILER@", cc
      s.gsub! "@BUILD_CXX_COMPILER@", cxx
    end

    inreplace "src/gromacs/gromacs-config.cmake.cmakein", "@GROMACS_CXX_COMPILER@", cxx

    args = %W[
      -DGROMACS_CXX_COMPILER=#{cxx}
      -DGMX_VERSION_STRING_OF_FORK=#{tap.user}
      -DGMX_INSTALL_LEGACY_API=ON
    ]

    # Force SSE2/SSE4.1 for compatibility when building Intel bottles
    if Hardware::CPU.intel?
      gmx_simd = if OS.mac? && MacOS.version.requires_sse4?
        "SSE4.1"
      else
        "SSE2"
      end
      args << "-DGMX_SIMD=#{gmx_simd}"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install "build/scripts/GMXRC" => "gromacs-completion.bash"
    bash_completion.install bin/"gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install bin/"gmx-completion.bash" => "gmx-completion.bash"
    zsh_completion.install "build/scripts/GMXRC.zsh" => "_gromacs"
  end

  def caveats
    <<~EOS
      GMXRC and other scripts installed to:
        #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end

  test do
    system "#{bin}/gmx", "help"
  end
end