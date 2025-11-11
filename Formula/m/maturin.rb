class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "e70110e9db4fb3aaf991ccd690abdfa7d1e74e6538024e0472441f4dd05c9024"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc144ee9cc1f5a8bdbbe2fdba4052256611ca4e10f826031ed26ac3d54d9885b"
    sha256 cellar: :any,                 arm64_sequoia: "f45b761982459a84cd5229f63ac758ff7215a9ffbf0616e5164a769a1bbebbf8"
    sha256 cellar: :any,                 arm64_sonoma:  "d687306b28bacb03fb8a3dc8c8c17b5ab8f7db16c37d31c8ee7b5efa463950e4"
    sha256 cellar: :any,                 sonoma:        "f5c60fe3f766fc133a57000b8d47b56f58ad9fa11f705dcbeda5301862738cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713d2a6f79a96865b6f0b57b96f96b3c61e60edad82b41ef40bee0150f49e2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc0715e78ad3da8bac57e743cd18e51da76e61dad1b6df95b76e25432c5ffe22"
  end

  depends_on "python@3.14" => :test
  depends_on "rust"

  uses_from_macos "bzip2"
  uses_from_macos "xz"

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