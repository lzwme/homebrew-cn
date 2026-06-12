class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "2737d32e7684a64df4758d7d58d1b19041697733a8bf254d4c987c416796c069"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0fc7854d03741282ba53d26d2a58595964a44194d85630d193665775998ed3e9"
    sha256 cellar: :any, arm64_sequoia: "ebde7591fecf61eee38f02104dd6138259dd467d34552d92e7d08c896a7affce"
    sha256 cellar: :any, arm64_sonoma:  "02caca822112f0a5a2c1040b5155416a3089ddc0f094c77365a9377404c5ddd8"
    sha256 cellar: :any, sonoma:        "b6e31622da8745d77364b59a418fb09260819a36a16ee440ce5d5a3290509e3f"
    sha256 cellar: :any, arm64_linux:   "1490cbc9638ecf0ae38cd22a7a972deb4707689fe7e0ce082b10a23a59d4d87c"
    sha256 cellar: :any, x86_64_linux:  "bf391a34b0f8d3a9bbcb68288654c4d3d01a7c42146cf71ff0023272bc90784e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => [:build, :test]
  depends_on "python@3.14" => :test
  depends_on "xz"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 recursive_dependencies.find { |d| d.name.match?(/^llvm(@\d+)?$/) }
                                       .to_formula
                                       .opt_lib
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"maturin", "completions")

    python_versions = Formula.names.filter_map do |name|
      Version.new(name.delete_prefix("python@")) if name.start_with?("python@")
    end.sort

    newest_python = python_versions.pop
    newest_python_site_packages = lib/"python#{newest_python}/site-packages"
    newest_python_site_packages.install "maturin"

    python_versions.each do |pyver|
      (lib/"python#{pyver}/site-packages/maturin").install_symlink (newest_python_site_packages/"maturin").children
    end
  end

  test do
    python3 = "python3.14"
    system "cargo", "init", "homebrew", "--name=brew", "--bin"
    cd "homebrew" do
      system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
      system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
      system python3, "-c", "import maturin"
    end
  end
end