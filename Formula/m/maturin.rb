class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://ghfast.top/https://github.com/PyO3/maturin/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "7fef666d3f91ddb91743a6a96cd4aec69654b7e9cb570c988890f147c27c11d1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb2d2024c4109c7198897096b4e11454a2d80528a249f936d9d1f54378ee85b8"
    sha256 cellar: :any,                 arm64_sequoia: "1038454e535328b27326566fcbb7740268efa09d8aa2954051f9afbc56fb5806"
    sha256 cellar: :any,                 arm64_sonoma:  "022ea96688bb1ef077b59f1e937ddf90a6e747589f3c784608e8c48d0d062ace"
    sha256 cellar: :any,                 sonoma:        "362c1f0cc8a5ecf0aeeb82cab9e99a1a369fa91c606dadcaacc046f8776b04e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f47891384e2f20b6845597f9170dbcd3f73f01887e37fb51cf1a83d4c528267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e04a5e4e39f493dd8cf866b3a57d52e472c5623ff1a6cc3589e15cee20f042fd"
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