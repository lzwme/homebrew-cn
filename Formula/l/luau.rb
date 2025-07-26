class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.684.tar.gz"
  sha256 "0783ed238f20bf879a89091da0c36d79db29c1a748e8d46077a89cd8922e5afe"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a36e19243d0f1df5825d91f72d3f7e3f5080b0aab3bf0f33f9a9d47b36528c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c92e92eb628f1400f09b23cdcacc5cc79b484540637ff69c970b8faff0527629"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2441e98d8ebc73c9581bdda1d17305b1421a0018a33448f568cf139161e86c36"
    sha256 cellar: :any_skip_relocation, sonoma:        "9815e9a859b1b20ed16652cfbf8157b858405740afacf509915ab1816f2b98f6"
    sha256 cellar: :any_skip_relocation, ventura:       "89f8796e8019cfd2c0ed43bd0d86dbea474339f46296892936524d1c705fb137"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfd8d80bb93fe29fb33f088878fb2d68058f36c31c08f3f26f2ae407c3dc5f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f674fadeb35e6a7fa7efe2529e583232730dfe591dfd6cf26af85d14583036c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end