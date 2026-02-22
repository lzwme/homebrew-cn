class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "a6db86fe870d200ba7492107540e49dd512bc0add1f9a2b910b9b5d4a42baa76"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4deefa7afcabce1839e4a93c40e0641fe12e94007f6ecea38a3c987b61ec4704"
    sha256 cellar: :any,                 arm64_sequoia: "b55406a9e1d6843d17b8a66639514ba916653c54e3586e72d2dc4d3a6cb680f8"
    sha256 cellar: :any,                 arm64_sonoma:  "f67b488ce1f8c5daa5708b74e44e58fb4e1cf9462240a63e27c47fb844a15d85"
    sha256 cellar: :any,                 sonoma:        "fd16bf31c045db428cca3a1437da6692042996c49feac9aaa84ebac1a10293f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5b7b105c789c0aa405ad51ce727f021b0adc9d266f3de6bf7081209772305a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e80a820530e5342fb37da7e8e878810f5f71c3e69f04bca9ce793d9c6eefa0ec"
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
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    system python3, "-c", "import maturin"
  end
end